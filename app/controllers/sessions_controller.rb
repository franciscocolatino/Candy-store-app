class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :index, :login ]

  def index
  end

  def login
    service = Users::Authenticate.call(login_params)

    if service.success?
      cookies.encrypted[:auth_token] = { value: service.result[:token], expires: 7.days }

      redirect_to root_path
    else
      flash.now[:alert] = "Usuário ou senha inválidos"
      render :index, status: :unauthorized
    end
  end

  def logout
    cookies.encrypted[:auth_token] = nil
    redirect_to login_path
  end

  private

  def login_params
    params.permit(:cpf, :password_digest, :commit)
  end
end
