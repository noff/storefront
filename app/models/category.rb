class Category < ApplicationRecord
  has_many :products

  # parent_id хранит ext_id (слаг) родительской категории из фида
  belongs_to :parent, class_name: "Category", primary_key: :ext_id,
             foreign_key: :parent_id, optional: true
  has_many :children, class_name: "Category", primary_key: :ext_id,
           foreign_key: :parent_id

  scope :roots, -> { where(parent_id: nil) }

  # В урлах и параметрах используется ext_id из фида, а не первичный ключ.
  def to_param
    ext_id
  end

  # Родители от корня к ближайшему. Сам объект в результат не входит.
  # Ограничение глубины — страховка от цикла parent_id в фиде.
  def ancestors(limit: 10)
    chain = []
    node = parent
    while node && chain.size < limit
      chain << node
      node = node.parent
    end
    chain.reverse
  end
end
