# frozen_string_literal: true

# Справочник городов. Хранится в коде, а не в БД: список фиксированный,
# а код города едет в cookie и должен валидироваться против белого списка.
class City
  attr_reader :code, :name

  def initialize(code, name)
    @code = code
    @name = name
    freeze
  end

  ALL = [
    new("moscow", "Москва"),
    new("spb", "Санкт-Петербург")
  ].freeze

  BY_CODE = ALL.index_by(&:code).freeze
  DEFAULT = BY_CODE.fetch("moscow")

  # Код из cookie — недоверенный ввод: всё, чего нет в белом списке, даёт nil.
  # @return [City, nil]
  def self.find(code)
    BY_CODE[code.to_s]
  end

  # @return [City]
  def self.find_or_default(code)
    find(code) || DEFAULT
  end
end
