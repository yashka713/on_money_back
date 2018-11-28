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

      private

      def profile_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
