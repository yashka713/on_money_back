module Api
  module V1
    class ProfilesController < BaseController
      skip_before_action :authenticate, only: :registration

      def registration
        user = User.new(profile_params)
        if user.save
          render_success user, 201
        else
          render_jsonapi_errors user
        end
      end

      def update
        if current_user.update(update_params)
          render_success current_user
        else
          render_jsonapi_errors current_user
        end
      end

      private

      def profile_params
        params.require(:user).permit(:email, :password)
      end

      def update_params
        params.require(:user).permit(:name, :nickname)
      end
    end
  end
end
