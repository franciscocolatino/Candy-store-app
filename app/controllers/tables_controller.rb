class TablesController < ApplicationController
    before_action :set_table, only: [ :show, :edit, :update, :destroy ]
    before_action :is_admin?, only: %i[create new edit update destroy]

    def index
        @tables= Table.all
        respond_to do |format|
            format.html
            format.json do
                if @tables.any?
                    render json: @tables
                else
                    head :no_content
                end
            end
        end
    end

    def show
        @order=@table.orders.find_by(is_finished: false)

        respond_to do |format|
            format.html
            format.json do
                if @table
                    render json: {
                        table: @table,
                        order: @order,
                        order_lots: @order&.order_lots&.includes(lot: :product)&.map do |ol|
                            {
                            quantity: ol.quantity,
                            subtotal: ol.subtotal,
                            product_name: ol.lot.product.name
                            }
                        end
                    }
                else
                    head :not_found
                end
            end
        end
    end

    def new
        @table = Table.new
    end

    def create
        if @current_user&.is_admin
            @table = Table.new(table_params)

            if @table.save
                respond_to do |format|
                    format.json { render json: @table, status: :created }
                    format.html { redirect_to tables_path, notice: "Mesa criada com sucesso." }
                end
            else
                respond_to do |format|
                    format.json { render json: @table.errors, status: :unprocessable_entity }
                    format.html { render :new, status: :unprocessable_entity }
                end
            end
        else
            head :unauthorized
        end
    end

    def edit
    end

    def update
        if @current_user&.is_admin
            if @table.update(table_params)
                respond_to do |format|
                    format.json { render json: @talbe, status: :ok }
                    format.html { redirect_to tables_path, notice: "Mesa atualizada com sucesso." }
                end
            else
                respond_to do |format|
                    format.json { render json: @table.errors, status: :unprocessable_entity }
                    format.html { render :edit, status: :unprocessable_entity }
                end
            end
        end
    end

    def destroy
        if @current_user&.is_admin
            if @table.orders.exists? 
                 redirect_to @table, alert: 'Não é possível excluir uma mesa que foi utilizada uma vez.'
            else
                @table.destroy
                redirect_to tables_path, notice: "Mesa removida com sucesso."
            end
        else
            redirect_to @table, alert: "Acesso não autorizado."
        end
    end

    private

    def is_admin?
        unless @current_user&.is_admin
            respond_to do |format|
                format.html { redirect_to tables_path, notice: "Apenas administradores podem fazer isso" }
                format.json { render json: { error: "Apenas administradores podem fazer isso" }, status: :forbidden }
            end
        end
    end

    def set_table
        @table=Table.find_by(id: params[:id])
    end
    def table_params
        params.require(:table).permit(:number)
    end
end
