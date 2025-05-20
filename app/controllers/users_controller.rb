class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[ new create ]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  
    respond_to do |format|
      format.html # renderiza views/users/index.html.erb
      format.json { render json: @users }
    end
  end
  
  

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        token = ::JsonWebToken.encode(cpf: @user.cpf)
        cookies.encrypted[:auth_token] = { value: token, expires: 7.days }
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      notice = if @user == @current_user && @user.cpf != user_update_params[:cpf]
                "Seu usuário foi atualizado com sucesso. Faça login novamente com o novo cpf."
               else
                "Usuário atualizado com sucesso."
               end
      if @user.update(user_update_params)
        format.html { redirect_to edit_user_path(@user), notice: notice }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Usuário foi destruído com sucesso." }
      format.json { head :no_content }
    end
  end

  def update_password
    @user = User.find(params[:id])

    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = 'As senhas não coincidem.'
      render :edit, status: :unprocessable_entity
      return
    end
    
    if @user.update(password: params[:password])
      redirect_to edit_user_path(@user), notice: 'Senha atualizada com sucesso.'
    else
      flash.now[:alert] = 'Erro ao atualizar a senha.'
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :cpf, :password)
    end

    def user_update_params
      params.require(:user).permit(:name, :cpf)
    end
end