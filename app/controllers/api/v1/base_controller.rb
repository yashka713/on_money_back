module Api
  module V1
    class BaseController < ::ApplicationController
      include JsonApi
      include Authenticatable

      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from ActionController::ParameterMissing, with: :render_400
      rescue_from ArgumentError, with: :render_400
      rescue_from CanCan::AccessDenied, with: :render_403

      before_action :authenticate
    end
  end
end
