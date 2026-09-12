class HomeController < ApplicationController
  # Демо-данные для вёрстки: моделей пока нет.
  # variant у баннера — модификатор CSS-класса (.hero-slide--*), а не цвет:
  # цвета живут в application.bootstrap.scss, чтобы обойтись без инлайновых стилей.
  def index
    @banners = [
      { title: "Осенняя распродажа", text: "Скидки до 50% на технику и аксессуары", cta: "Смотреть товары", variant: "sale" },
      { title: "Новая коллекция", text: "Только что приехало на склад", cta: "Открыть каталог", variant: "new" },
      { title: "Бесплатная доставка", text: "При заказе от 3 000 ₽ по всей России", cta: "Узнать подробнее", variant: "delivery" }
    ]

    @stories = [ "Новинки", "Хиты", "Скидки", "Отзывы", "Бренды", "Подборки", "Гаджеты" ]

    @products = [
      { title: "Беспроводные наушники Air Pro", price: 7_990, old_price: 11_490, rating: 5 },
      { title: "Смарт-часы Nova Fit 3", price: 12_450, old_price: nil, rating: 4 },
      { title: "Механическая клавиатура K68", price: 5_390, old_price: 6_900, rating: 4 },
      { title: "Игровая мышь Sprint X", price: 2_790, old_price: nil, rating: 5 },
      { title: "Портативная колонка Bass Mini", price: 3_490, old_price: 4_990, rating: 3 },
      { title: "Монитор 27\" QHD 165 Гц", price: 29_900, old_price: 34_500, rating: 5 },
      { title: "Внешний SSD 1 ТБ", price: 8_750, old_price: nil, rating: 4 },
      { title: "Веб-камера Stream HD", price: 4_120, old_price: 5_300, rating: 4 },
      { title: "Настольная лампа Lumen", price: 2_150, old_price: nil, rating: 3 },
      { title: "Рюкзак для ноутбука 16\"", price: 3_980, old_price: 5_600, rating: 5 }
    ]

    @deal = { title: "Робот-пылесос Clean S9", price: 19_990, old_price: 32_900, rating: 5 }
  end
end
