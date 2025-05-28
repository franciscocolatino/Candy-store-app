import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = [
    "type", "startDate", "endDate", "isFinished", "minTotal", "maxTotal",
    "output", "tableContainer", "tableBody", "chart", "loadBtn", "orderFilters"
  ]

  connect() {
    this.toggleFilters()

    console.log("[Stimulus] Dashboard controller conectado.")    
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  toggleFilters() {
    this.orderFiltersTarget.style.display = this.typeTarget.value === "orders" ? "block" : "none"
    this.clearDashboard()
  }

  clearDashboard() {
    this.outputTarget.textContent = "Selecione um tipo de dashboard..."
    this.tableContainerTarget.classList.add("hidden")
    this.chartTarget.style.display = "none"
    if (window.myChart) {
      window.myChart.destroy()
      window.myChart = null
    }
  }

  unsubscribe() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  async loadDashboard() {
    this.unsubscribe()
    this.loadBtnTarget.disabled = true
    this.loadBtnTarget.textContent = "Carregando..."

    const type = this.typeTarget.value
    const params = new URLSearchParams({ type })

    if (type === "orders") {
      if (this.startDateTarget.value) params.append("start_date", this.startDateTarget.value)
      if (this.endDateTarget.value) params.append("end_date", this.endDateTarget.value)
      if (this.isFinishedTarget.value !== "") params.append("is_finished", this.isFinishedTarget.value)
      if (this.minTotalTarget.value) params.append("min_total", this.minTotalTarget.value)
      if (this.maxTotalTarget.value) params.append("max_total", this.maxTotalTarget.value)
    }

    this.outputTarget.textContent = "Carregando relatório..."
    this.tableContainerTarget.classList.add("hidden")
    this.chartTarget.style.display = "none"

    try {
      const res = await fetch(`/dashboard?${params.toString()}`, {
        headers: { Accept: "application/json" }
      })

      if (!res.ok) throw new Error("Erro na requisição")
      const data = await res.json()
      const result = data.result || data

      this.subscription = consumer.subscriptions.create(
        { 
          channel: "DashboardChannel", 
          type: type, ...(type === "orders" ? {
            start_date: this.startDateTarget.value,
            end_date: this.endDateTarget.value,
            is_finished: this.isFinishedTarget.value,
            min_total: this.minTotalTarget.value,
            max_total: this.maxTotalTarget.value
          } : {})
        },
        {
          connected: () => {
            console.log(`[Cable] Conectado ao canal ${type}`)
          },
          disconnected: () => {
            console.log(`[Cable] Desconectado do canal ${type}`)
          },
          received: (data_broadcast) => {
            console.log(`[Cable] Dados recebidos no canal ${type}:`, data_broadcast)
            if (type === "orders") {
              if (data_broadcast.refresh) this.transmitOrdersWithFilters()
              if (data_broadcast.summary) this.renderOrdersSummary(data_broadcast.summary)
              if (data_broadcast.orders) this.renderOrdersTable(data_broadcast.orders)
              if (data_broadcast.chart_data) this.renderOrdersChart(data_broadcast.chart_data)
            } else if (type === "stock") {
              this.renderStockSummary(data_broadcast)
              this.renderStockChart(data_broadcast)
            }
          }
        }
      )

      if (type === "orders") {
        this.renderOrdersSummary(result.summary)
        this.renderOrdersTable(result.orders)
        this.renderOrdersChart(result.chart_data)
      } else if (type === "stock") {
        this.renderStockSummary(result)
        this.renderStockChart(result)
      } else {
        this.outputTarget.textContent = JSON.stringify(result, null, 2)
      }
    } catch (err) {
      this.outputTarget.textContent = "Erro ao carregar relatório."
      console.error(err)
    } finally {
      this.loadBtnTarget.disabled = false
      this.loadBtnTarget.textContent = "Carregar"
    }
  }

  transmitOrdersWithFilters() {
    this.subscription.perform("transmit_orders_with_filters", {
      start_date: this.startDateTarget.value,
      end_date: this.endDateTarget.value,
      is_finished: this.isFinishedTarget.value,
      min_total: this.minTotalTarget.value,
      max_total: this.maxTotalTarget.value
    })
    return 
  }

  renderOrdersSummary(summary) {
    this.outputTarget.innerHTML = `
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="bg-blue-50 p-4 rounded-lg">
          <h3 class="text-sm font-medium text-blue-800">Total de Pedidos</h3>
          <p class="text-2xl font-bold text-blue-600">${summary.total_orders}</p>
        </div>
        <div class="bg-green-50 p-4 rounded-lg">
          <h3 class="text-sm font-medium text-green-800">Faturamento Total</h3>
          <p class="text-2xl font-bold text-green-600">R$ ${summary.total_revenue.toFixed(2).replace('.', ',')}</p>
        </div>
        <div class="bg-purple-50 p-4 rounded-lg">
          <h3 class="text-sm font-medium text-purple-800">Ticket Médio</h3>
          <p class="text-2xl font-bold text-purple-600">R$ ${summary.average_order_value.toString().replace('.', ',')}</p>
        </div>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
        <div class="bg-yellow-50 p-4 rounded-lg">
          <h3 class="text-sm font-medium text-yellow-800">Pedidos Finalizados</h3>
          <p class="text-2xl font-bold text-yellow-600">${summary.orders_finished}</p>
        </div>
        <div class="bg-red-50 p-4 rounded-lg">
          <h3 class="text-sm font-medium text-red-800">Pedidos Pendentes</h3>
          <p class="text-2xl font-bold text-red-600">${summary.orders_unfinished}</p>
        </div>
      </div>
    `
  }

  renderOrdersTable(orders) {
    this.tableBodyTarget.innerHTML = ""
    if (!orders.length) {
      this.tableContainerTarget.classList.add("hidden")
      return
    }

    orders.forEach(order => {
      const tr = document.createElement("tr")
      tr.classList.add("hover:bg-gray-50")
      tr.innerHTML = `
        <td class="px-4 py-2 whitespace-nowrap">${order.id}</td>
        <td class="px-4 py-2 whitespace-nowrap">${order.date}</td>
        <td class="px-4 py-2 whitespace-nowrap">${order.is_finished ? 'Finalizado' : 'Pendente'}</td>
        <td class="px-4 py-2 whitespace-nowrap">R$ ${Number(order.total_price || 0).toFixed(2)}</td>
      `
      this.tableBodyTarget.appendChild(tr)
    })

    this.tableContainerTarget.classList.remove("hidden")
  }

  renderOrdersChart(data) {
    const ctx = this.chartTarget.getContext("2d")
    if (window.myChart) window.myChart.destroy()

    window.myChart = new Chart(ctx, {
      type: "line",
      data: {
        labels: data.labels,
        datasets: [{
          label: "Pedidos por dia",
          data: data.values,
          backgroundColor: "rgba(79, 70, 229, 0.1)",
          borderColor: "rgba(79, 70, 229, 0.8)",
          borderWidth: 2,
          tension: 0.3
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true },
          x: {}
        }
      }
    })

    this.chartTarget.style.display = "block"
  }

  renderStockSummary(data) {
    this.outputTarget.innerHTML = `
      <p class="text-lg font-semibold mb-4">Resumo do Estoque</p>
      <p><strong>Total de itens no estoque:</strong> ${data.total_stock_items}</p>
    `

    let html = `<table class="min-w-full divide-y divide-gray-200 table-auto mt-6">
      <thead><tr><th class="px-4 py-2">Produto</th><th class="px-4 py-2">Quantidade</th></tr></thead><tbody>`

    for (const [product, quantity] of Object.entries(data.stock_per_product)) {
      html += `<tr><td class="px-4 py-2">${product}</td><td class="px-4 py-2">${quantity}</td></tr>`
    }

    html += "</tbody></table>"
    this.outputTarget.innerHTML += html
  }

  renderStockChart(data) {
    const ctx = this.chartTarget.getContext("2d")
    if (window.myChart) window.myChart.destroy()

    window.myChart = new Chart(ctx, {
      type: "bar",
      data: {
        labels: Object.keys(data.stock_per_product),
        datasets: [{
          label: "Quantidade em estoque",
          data: Object.values(data.stock_per_product),
          backgroundColor: "rgba(99, 102, 241, 0.7)",
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true },
          x: {}
        }
      }
    })

    this.chartTarget.style.display = "block"
  }
}
