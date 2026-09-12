class Category < ApplicationRecord
  has_many :products

  # parent_id хранит ext_id (слаг) родительской категории из фида
  belongs_to :parent, class_name: "Category", primary_key: :ext_id,
             foreign_key: :parent_id, optional: true
  has_many :children, class_name: "Category", primary_key: :ext_id,
           foreign_key: :parent_id

  scope :roots, -> { where(parent_id: nil) }
end
