class LotsController < ApplicationController
  before_action :set_product
  before_action :set_lot, only: [:show, :edit, :update, :destroy]

  def index
    @lots = @product.lots.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.json { render json: @lots }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @lot }
    end

  def new
    @lot = @product.lots.build
  end

  def create
    @lot = @product.lots.build(lot_params)

    respond_to do |format|
      if @lot.save
        format.html { redirect_to product_lots_path(@product), notice: 'Lote criado com sucesso.' }
        format.json { render json: @lot, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lot.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @lot.update(lot_params)
        format.html { redirect_to product_lots_path(@product), notice: 'Lote atualizado com sucesso.' }
        format.json { render json: @lot, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lot.destroy

    respond_to do |format|
      format.html { redirect_to product_lots_path(@product), notice: 'Lote removido com sucesso.' }
      format.json { render json: { message: 'Lot deleted' }, status: :ok }
    end
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
