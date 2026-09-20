# frozen_string_literal: true

# Builder приезжает с actionview, но сам Rails его не подгружает.
require "builder"

module Feed
  # Генерация товарного фида в формате YML (Yandex Market) по спецификации REES46:
  # https://rees46.ru/help/integration/catalog/import/yml/
  #
  # call возвращает Enumerator, отдающий XML кусками: шапка, категории,
  # затем по одному офферу. Документ целиком в памяти не собирается — каталог
  # может быть на десятки тысяч позиций.
  class Yml < ApplicationService
    CATEGORY_BATCH = 1000
    PRODUCT_BATCH = 500

    # Витрина работает в одной валюте, курсов нет.
    CURRENCY = "RUB"

    attr_reader :base_url

    # @param [String] base_url корень витрины, например "http://localhost:3000"
    def initialize(base_url:)
      @base_url = base_url.to_s.chomp("/")
    end

    # @return [Enumerator<String>]
    def call
      Enumerator.new do |out|
        out << header
        out << categories_xml
        out << "    <offers>\n"
        each_offer { |offer| out << offer }
        out << "    </offers>\n"
        out << "  </shop>\n</yml_catalog>\n"
      end
    end

    private

    def header
      xml = builder
      xml.tag!("name", shop_name)
      xml.tag!("company", shop_company)
      xml.tag!("url", base_url)
      xml.currencies do
        xml.currency(id: CURRENCY, rate: "1")
      end
      # Справочник локаций, на который ссылаются <location id> внутри офферов.
      # Дерево плоское: в City есть только города, ни регионов, ни пунктов выдачи.
      xml.locations do
        City::ALL.each do |city|
          xml.location(id: city.code, type: "city", name: city.name)
        end
      end

      # Пролог собираем строкой: XML-декларация обязана стоять в самом начале
      # файла, а Builder с margin сдвинул бы её отступом.
      # Формат даты жёстко задан спецификацией: YYYY-MM-DD hh:mm.
      <<~XML + xml.target!
        <?xml version="1.0" encoding="UTF-8"?>
        <yml_catalog date="#{Time.current.strftime('%Y-%m-%d %H:%M')}">
          <shop>
      XML
    end

    def categories_xml
      xml = builder
      xml.categories do
        Category.find_each(batch_size: CATEGORY_BATCH) do |category|
          attrs = { id: category.ext_id, url: category_url(category) }
          attrs[:parentId] = category.parent_id if category.parent_id.present?
          xml.category(category.name, attrs)
        end
      end
      xml.target!
    end

    def each_offer
      Product.includes(:category).find_each(batch_size: PRODUCT_BATCH) do |product|
        # Оффер без цены REES46 не примет, а нулевую цену подставлять нельзя —
        # она исказит рекомендации. Такие товары пропускаем.
        next if product.price.blank?

        yield offer_xml(product)
      end
    end

    def offer_xml(product)
      xml = builder
      xml.offer(id: product.ext_id, available: product.available ? "true" : "false") do
        xml.tag!("name", product.name)
        xml.tag!("url", product_url(product))
        xml.tag!("price", product.price)

        if old_price?(product)
          xml.tag!("oldprice", product.old_price)
          xml.tag!("discount_percent", product.discount)
        end

        xml.tag!("picture", product.picture) if product.picture.present?
        xml.tag!("categoryId", product.category.ext_id) if product.category
        xml.tag!("vendor", product.vendor) if product.vendor.present?
        xml.tag!("description", product.description) if product.description.present?
        # Спецификация требует целое 1–5, в базе рейтинг дробный.
        xml.tag!("rating", product.rating.round) if product.rating.present?

        product.parsed_params.each do |param|
          xml.param(param["value"], name: param["name"])
        end

        locations_xml(xml, product)
      end
      xml.target!
    end

    # Цен и остатков по городам в данных нет: секция перечисляет города, в которых
    # товар доступен (сейчас — весь справочник), с ценой оффера.
    def locations_xml(xml, product)
      xml.locations do
        City::ALL.each do |city|
          xml.location(id: city.code) do
            xml.tag!("price", product.price)
            xml.tag!("oldprice", product.old_price) if old_price?(product)
          end
        end
      end
    end

    def old_price?(product)
      product.old_price.present? && product.old_price > product.price
    end

    def builder
      ::Builder::XmlMarkup.new(indent: 2, margin: 2)
    end

    # Ссылки ведут на карточки внутри витрины, а не на url из исходного фида.
    def product_url(product)
      routes.product_url(product, host: base_url)
    end

    def category_url(category)
      routes.category_url(category, host: base_url)
    end

    def routes
      Rails.application.routes.url_helpers
    end

    def shop_name
      ENV.fetch("FEED_SHOP_NAME", "Storefront")
    end

    def shop_company
      ENV.fetch("FEED_SHOP_COMPANY", "Storefront")
    end
  end
end
