// app/javascript/controllers/users/cpf_validator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]

  connect() {
    this.validateHandler = this.validate.bind(this)
    this.revalidateHandler = this.revalidate.bind(this)

    this.form = this.element.closest("form")
    this.form.addEventListener("submit", this.validateHandler)
    this.inputTarget.addEventListener("blur", this.revalidateHandler)
  }

  disconnect() {
    this.form.removeEventListener("submit", this.validateHandler)
    this.inputTarget.removeEventListener("blur", this.revalidateHandler)
  }

  validate(event) {
    const cpf = this.cleanedCPF()
    this.hideError()

    if (!this.isValidCPF(cpf)) {
      event.preventDefault()
      this.showError()
    }
  }

  revalidate() {
    const cpf = this.cleanedCPF()
    if (this.isValidCPF(cpf)) {
      this.hideError()
    } else {
      this.showError()
    }
  }

  cleanedCPF() {
    return this.inputTarget.value.replace(/[^\d]+/g, "")
  }

  isValidCPF(cpf) {
    return /^\d{11}$/.test(cpf)
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
