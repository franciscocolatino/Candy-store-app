// app/javascript/controllers/users/cpf_validator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]

  connect() {
    this.form = this.element.closest("form")
    this.form.addEventListener("submit", this.validate.bind(this))
  }

  validate(event) {
    const cpf = this.inputTarget.value.replace(/[^\d]+/g, "")
    this.hideError()

    if (!this.isValidCPF(cpf)) {
      event.preventDefault()
      this.showError()
    }
  }

  isValidCPF(cpf) {
    if (cpf.length !== 11 || /^(\d)\1+$/.test(cpf)) return false

    let soma = 0, resto

    for (let i = 1; i <= 9; i++) soma += parseInt(cpf[i - 1]) * (11 - i)
    resto = (soma * 10) % 11
    if (resto === 10 || resto === 11) resto = 0
    if (resto !== parseInt(cpf[9])) return false

    soma = 0
    for (let i = 1; i <= 10; i++) soma += parseInt(cpf[i - 1]) * (12 - i)
    resto = (soma * 10) % 11
    if (resto === 10 || resto === 11) resto = 0
    return resto === parseInt(cpf[10])
  }

  showError() {
    this.errorTarget.classList.remove("hidden")
    this.inputTarget.classList.add(
      "border-red-500",
      "ring-1",
      "ring-red-500",
      "focus:border-red-500",
      "focus:ring-red-500"
    )
  }

  hideError() {
    this.errorTarget.classList.add("hidden")
    this.inputTarget.classList.remove(
      "border-red-500",
      "ring-1",
      "ring-red-500",
      "focus:border-red-500",
      "focus:ring-red-500"
    )
  }
}
