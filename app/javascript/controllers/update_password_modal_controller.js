import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "modal", "form", "error"]

  open() {
    console.log(this.boxTarget)
    this.modalTarget.classList.remove("hidden")
    requestAnimationFrame(() => {
      this.boxTarget.classList.remove("opacity-0", "scale-95")
    })
  }

  close() {
    this.boxTarget.classList.add("opacity-0", "scale-95")
    setTimeout(() => {
      this.modalTarget.classList.add("hidden")
    }, 300)
  }
  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }  

  validate(event) {
    const passwordInput = this.formTarget.querySelector("input[name='password']")
    const confirmationInput = this.formTarget.querySelector("input[name='password_confirmation']")
  
    if (!passwordInput || !confirmationInput) return
  
    const password = passwordInput.value
    const confirmation = confirmationInput.value
  
    if (password !== confirmation) {
      event.preventDefault()
      this.errorTarget.classList.remove("hidden")
      this.errorTarget.textContent = "As senhas não coincidem."
    } else {
      this.errorTarget.classList.add("hidden")
      this.errorTarget.textContent = ""
    }
  }
}
