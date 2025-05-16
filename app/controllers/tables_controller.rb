class TablesController < ApplicationController
    before_action :set_table, only: [:show, :edit, :update]

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

        respond_to do |format|
            format.html 
            format.json do
                if @table
                    render json: @table
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
                    format.html { redirect_to tables_path, notice: 'Mesa criada com sucesso.' }
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
                    format.html { redirect_to tables_path, notice: 'Mesa atualizada com sucesso.' }
                end
            else
                respond_to do |format|
                    format.json { render json: @table.errors, status: :unprocessable_entity }
                    format.html { render :edit, status: :unprocessable_entity }
                end
            end
        end
    end        


    private

    def set_table
        @table=Table.find_by(id: params[:id])
    end
    def table_params
        params.require(:table).permit(:number)
    end
end