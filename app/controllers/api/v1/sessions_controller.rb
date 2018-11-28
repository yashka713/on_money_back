module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate, only: :create

      def create
        user = User.find_by(email: auth_params[:email])
        if user&.authenticate(auth_params[:password])
          render_success user
        else
          render_401
        end
      end

      def check_user
        render_success current_user
      end

      private

      def auth_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
