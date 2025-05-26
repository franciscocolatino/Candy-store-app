import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  connect() {
    console.log("[Stimulus] Dashboard controller conectado.")

    this.subscription = consumer.subscriptions.create("DashboardChannel", {
      connected: () => {
        console.log("[Cable] Conectado ao DashboardChannel")
      },
      disconnected: () => {
        console.log("[Cable] Desconectado do DashboardChannel")
      },
      received: (data) => {
        console.log("[Cable] Dados recebidos:", data)
        // Aqui você pode manipular o DOM com this.element, etc.
      }
    })
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }
}
