class LotsController < ApplicationController
  before_action :set_product
  before_action :set_lot, only: [:show, :edit, :update, :destroy]

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
      redirect_to product_lots_path(@product), notice: 'Lote criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lot.update(lot_params)
      redirect_to product_lots_path(@product), notice: 'Lote atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lot.destroy
    redirect_to product_lots_path(@product), notice: 'Lote removido com sucesso.'
  end

  private

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
