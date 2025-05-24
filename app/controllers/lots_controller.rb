class LotsController < ApplicationController
  before_action :set_product
  before_action :set_lot, only: [ :show, :edit, :update, :destroy ]
  before_action :is_admin?, only: %i[create update destroy]

  def index
    @lots = @product.lots.order(created_at: :desc)
  end

  def show
  end

  def new
    @lot = @product.lots.build
  end

  def create
    @lot = @product.lots.build(lot_params)

    if @lot.save
      redirect_to product_lots_path(@product), notice: "Lote criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lot.update(lot_params)
      redirect_to product_lots_path(@product), notice: "Lote atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lot.destroy
    redirect_to product_lots_path(@product), notice: "Lote removido com sucesso."
  end

  private

  def is_admin?
    unless current_user&.is_admin
      respond_to do |format|
        format.html { redirect_to products_url, notice: "Apenas administradores podem fazer isso" }
        format.json { render json: { error: "Apenas administradores podem fazer isso" }, status: :forbidden }
      end
    end
  end
  
  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_lot
    @lot = @product.lots.find(params[:id])
  end

  def lot_params
    params.require(:lot).permit(:quantity, :expiration_date, :manufacturing_date)
  end
end
