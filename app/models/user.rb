class User < ApplicationRecord
  # Простейший набор модулей: регистрация без подтверждения email.
  # Доступны также :confirmable, :lockable, :timeoutable, :trackable, :omniauthable.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
end
