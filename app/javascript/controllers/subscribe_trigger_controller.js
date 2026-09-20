import { Controller } from "@hotwired/stimulus"

// Подписка на триггерные рассылки REES46 (снижение цены, появление в наличии).
// Вызов чисто клиентский: r46 уже инициализирован в layout'е, серверный роут не нужен.
export default class extends Controller {
  static targets = [ "button", "status" ]
  static values = {
    event: String,
    payload: Object,
    doneText: String
  }

  subscribe() {
    if (this.subscribed) return

    if (typeof window.r46 !== "function") {
      this.#showStatus("Не удалось оформить подписку — попробуйте позже.")
      return
    }

    window.r46("subscribe_trigger", this.eventValue, this.payloadValue)
    this.subscribed = true

    this.buttonTarget.disabled = true
    this.buttonTarget.classList.remove("btn-outline-primary")
    this.buttonTarget.classList.add("btn-success")
    this.buttonTarget.innerHTML =
      '<i class="bi bi-check2 me-2" aria-hidden="true"></i>Вы подписаны'

    this.#showStatus(this.doneTextValue)
  }

  #showStatus(message) {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = message
    this.statusTarget.classList.remove("d-none")
  }
}
