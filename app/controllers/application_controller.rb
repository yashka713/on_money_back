class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parametrs, if: :devise_controller?

  protected
  def configure_permitted_parametrs
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
