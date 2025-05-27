class Order < ApplicationRecord
	belongs_to :table, optional: true
	belongs_to :user, foreign_key: 'user_cpf', primary_key: 'cpf'
	has_many :order_lots, dependent: :destroy

	validates :total_price, numericality: { greater_than_or_equal_to: 0 }

	after_update :broadcast_stock_update

	private

	def broadcast_stock_update
		payload = Dashboards::Stock.new.call.result

		ActionCable.server.broadcast("dashboard_channel_stock", payload)
	end
end
