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
    @products = Product.take(100).sample 10
    @deal = Product.take
    @categories = Category.where(parent_id: nil).order(:name)
  end
end
