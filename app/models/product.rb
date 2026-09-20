class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :order_items, dependent: :nullify

  # В урлах и параметрах используется ext_id из фида, а не первичный ключ.
  def to_param
    ext_id
  end

  # params хранится как JSON-массив пар: [{"name" => "Цвет", "value" => "Черный"}, ...]
  # Массив, а не хеш: в фиде имена повторяются и порядок характеристик важен.
  def parsed_params
    JSON.parse(params.presence || "[]")
  rescue JSON::ParserError
    []
  end

  # Возвращает процент скидки
  # @return [Numeric, nil]
  def discount
    return if price.blank? || old_price.blank? || old_price <= price
    (100.0 * (old_price - price) / old_price).floor
  end
end
