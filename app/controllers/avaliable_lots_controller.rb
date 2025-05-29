class AvaliableLotsController < ApplicationController
    def index
        @order = Order.find(params[:order_id])
        @lots= Lot.includes(:product).where("quantity>0")
        respond_to do |format|
            format.html
            format.json do
                if @lots.any?
                    render json: @lots
                else
                    head :no_content
                end
            end
        end
    end
end
