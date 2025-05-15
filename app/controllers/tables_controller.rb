class TablesController < ApplicationController
    

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


    private

    def table_params
        params.require(:table).permit(:number)
    end
end