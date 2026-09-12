class Product < ApplicationRecord
  belongs_to :category, optional: true

  # params хранится как JSON-массив пар: [{"name" => "Цвет", "value" => "Черный"}, ...]
  # Массив, а не хеш: в фиде имена повторяются и порядок характеристик важен.
  def parsed_params
    JSON.parse(params.presence || "[]")
  rescue JSON::ParserError
    []
  end
end
