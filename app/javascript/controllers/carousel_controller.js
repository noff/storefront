import { Controller } from "@hotwired/stimulus"

// Bootstrap-карусель, переживающая навигацию Turbo Drive:
// data-api Bootstrap'а инициализирует [data-bs-ride] только по DOMContentLoaded,
// которого при переходах Turbo нет. Stimulus поднимает инстанс на connect
// и корректно освобождает его перед кешированием страницы.
export default class extends Controller {
  connect() {
    // UMD-бандл Bootstrap регистрирует себя в window.bootstrap (см. application.js).
    this.carousel = window.bootstrap.Carousel.getOrCreateInstance(this.element, { ride: "carousel" })
  }

  disconnect() {
    this.carousel?.dispose()
    this.carousel = null
  }
}
