require "nokogiri"

namespace :products do
  desc "Импорт YML-фида (категории и товары) из XML: rake products:import[path/to/products.xml]"
  task :import, [ :path ] => :environment do |_t, args|
    path = args[:path].presence || Rails.root.join("products.xml").to_s
    abort "Файл не найден: #{path}" unless File.exist?(path)

    puts "Импорт из #{path} (#{(File.size(path) / 1024.0 / 1024).round(1)} МБ)"

    slug_to_id = Importer.import_categories(path)
    Importer.import_products(path, slug_to_id)

    puts "Готово. Категорий: #{Category.count}, товаров: #{Product.count}"
  end

  module Importer
    CATEGORY_BATCH = 1000
    PRODUCT_BATCH = 500

    module_function

    # Проход 1: <categories>/<category id parentId url>Название</category>
    def import_categories(path)
      now = Time.current
      rows = []
      total = 0

      each_element(path, "category") do |node|
        rows << {
          ext_id: node["id"],
          parent_id: node["parentId"].presence,
          url: node["url"],
          name: node.text.strip,
          created_at: now,
          updated_at: now
        }

        if rows.size >= CATEGORY_BATCH
          total += flush_categories(rows)
          puts "  категорий: #{total}"
        end
      end
      total += flush_categories(rows)

      puts "Категорий обработано: #{total}"
      Category.pluck(:ext_id, :id).to_h
    end

    # Проход 2: <offers>/<offer id available>...</offer>
    def import_products(path, slug_to_id)
      now = Time.current
      rows = []
      total = 0
      orphans = 0

      each_element(path, "offer") do |node|
        category_slug = node.at_xpath("categoryId")&.text
        category_id = slug_to_id[category_slug]
        orphans += 1 if category_id.nil?

        params = node.xpath("param").map do |p|
          { "name" => p["name"], "value" => p.text.strip }
        end

        rows << {
          ext_id: node["id"],
          available: node["available"] == "true",
          name: node.at_xpath("name")&.text,
          price: node.at_xpath("price")&.text.presence&.to_i,
          old_price: node.at_xpath("oldprice")&.text.presence&.to_i,
          picture: node.at_xpath("picture")&.text,
          url: node.at_xpath("url")&.text,
          vendor: node.at_xpath("vendor")&.text,
          category_id: category_id,
          params: JSON.generate(params),
          created_at: now,
          updated_at: now
        }

        if rows.size >= PRODUCT_BATCH
          total += flush_products(rows)
          puts "  товаров: #{total}"
        end
      end
      total += flush_products(rows)

      puts "Товаров обработано: #{total} (без известной категории: #{orphans})"
      total
    end

    # Потоковый обход файла: отдаёт каждый элемент с именем name как Nokogiri-узел.
    # Reader не держит документ в памяти, поэтому 125 МБ читаются за константную память.
    def each_element(path, name)
      File.open(path) do |file|
        Nokogiri::XML::Reader(file).each do |reader|
          next unless reader.name == name && reader.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          next if reader.outer_xml.blank?

          node = Nokogiri::XML(reader.outer_xml).root
          yield node if node
        end
      end
    end

    def flush_categories(rows)
      return 0 if rows.empty?

      count = rows.size
      Category.upsert_all(rows.uniq { |r| r[:ext_id] }, unique_by: :ext_id)
      rows.clear
      count
    end

    def flush_products(rows)
      return 0 if rows.empty?

      count = rows.size
      Product.upsert_all(rows.uniq { |r| r[:ext_id] }, unique_by: :ext_id)
      rows.clear
      count
    end
  end
end
