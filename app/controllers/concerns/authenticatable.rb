module Authenticatable
  extend ActiveSupport::Concern

  def self.included(clazz)
    clazz.class_eval do
      rescue_from JWT::DecodeError do |exception|
        render_401(exception)
      rescue JWT::DecodeError
        nil
      end

      rescue_from JWT::VerificationError do |exception|
        render_401(exception)
      rescue JWT::VerificationError
        nil
      end
    end
  end

  def authenticate
    render_401 unless logged_in?
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: auth['data']) if auth_present?
  end

  private

  def token
    request.env['HTTP_AUTHORIZATION'].scan(/Bearer(.*)$/).flatten.last.strip
  end

  def auth
    Auth.decode(token)
  end

  def auth_present?
    !request.env.fetch('HTTP_AUTHORIZATION', '').scan(/Bearer/).flatten.first.nil?
  end
end
