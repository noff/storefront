class User < ApplicationRecord
  # Простейший набор модулей: регистрация без подтверждения email.
  # Доступны также :confirmable, :lockable, :timeoutable, :trackable, :omniauthable.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
