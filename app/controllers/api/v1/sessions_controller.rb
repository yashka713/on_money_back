module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.where(email: params[:email]).first

        if user.valid_password?(params[:password]) && user
          render json: user.as_json(only: %i[email authentication_token]), status: :created
        else
          head(:unauthorized)
        end
      end

      def destroy; end
    end
  end
end
