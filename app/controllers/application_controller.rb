class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_request

  def authenticate_request
    @current_user = Users::CheckAuth.call(cookies).result
    
    redirect_to login_path unless @current_user
  end
end
