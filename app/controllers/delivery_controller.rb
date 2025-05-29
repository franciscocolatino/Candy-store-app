class DeliveryController < ApplicationController
    def index
        @deliveries = Order.where(table_id: nil).order(created_at: :desc)
        render :index
    end
end