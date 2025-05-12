class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

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
        format.html { redirect_to @product, notice: 'Produto criado com sucesso.' }
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
        format.html { redirect_to @product, notice: 'Produto atualizado com sucesso.' }
      end
    else
      respond_to do |format|
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end  

  def destroy
    @product.destroy
    respond_to do |format|
      format.json { render json: { message: "#{@product.name} deleted" }, status: :ok }
      format.html { redirect_to products_url, notice: 'Produto removido com sucesso.' }
    end
  end
    
  def inventory
    @product = Product.find(params[:id])
    @lots = @product.lots.order(created_at: :desc)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category, :price)
  end
end
