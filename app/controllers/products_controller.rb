class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]
  before_action :is_admin?, only: %i[create edit update destroy]

  def index
    @products = Product.all
    respond_to do |format|
      format.html
      format.json do
        if @products.any?
          render json: @products
        else
          head :no_content
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        if @product
          render json: @product
        else
          head :not_found
        end
      end
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      respond_to do |format|
        format.json { render json: @product, status: :created }
        format.html { redirect_to @product, notice: "Produto criado com sucesso." }
      end
    else
      respond_to do |format|
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end

  def update
    if @product.update(product_params)
      respond_to do |format|
        format.json { render json: @product, status: :ok }
        format.html { redirect_to @product, notice: "Produto atualizado com sucesso." }
      end
    else
      respond_to do |format|
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @current_user&.is_admin
      @product.destroy
      respond_to do |format|
        format.json { render json: { message: "#{@product.name} deleted" }, status: :ok }
        format.html { redirect_to products_url, notice: "Produto removido com sucesso." }
      end
    else
      redirect_to products_url, notice: "Apenas administradores podem remover produtos."
    end
  end

  def inventory
    @product = Product.find(params[:id])
    @lots = @product.lots.order(created_at: :desc)
  end

  private

  def is_admin?
    unless @current_user&.is_admin
      respond_to do |format|
        format.html { redirect_to products_url, notice: "Apenas administradores podem fazer isso" }
        format.json { render json: { error: "Apenas administradores podem fazer isso" }, status: :forbidden }
      end
    end
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category, :price)
  end
end
