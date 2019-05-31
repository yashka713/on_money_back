module Api
  module V1
    class PasswordsController < BaseController
      def update
        current_user.reset_password!(change_password_params)

        return render_jsonapi_errors current_user if current_user.errors.any?

        render_success({})
      end

      private

      def change_password_params
        params.require(:new_password).permit(:password, :password_confirmation)
      end
    end
  end
end
