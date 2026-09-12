// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
// UMD-бандл: экспортов у модуля нет, он регистрирует window.bootstrap как побочный эффект.
// Импортируем до контроллеров, чтобы глобаль был готов к первому connect().
import "bootstrap"
import "controllers"
