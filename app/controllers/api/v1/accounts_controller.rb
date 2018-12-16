module Api
  module V1
    class AccountsController < BaseController
      before_action :set_account, except: %i[index create]
      before_action :render_404_if_hidden, only: %i[show update destroy]

      def index
        render_success Account.active_accounts(current_user)
      end

      def create
        account = current_user.accounts.new(create_account_params)
        if account.save
          render_success account, 201
        else
          render_jsonapi_errors account
        end
      end

      def show
        render_success @account
      end

      def update
        if @account.update(update_account_params)
          render_success @account
        else
          render_jsonapi_errors @account
        end
      end

      def destroy
        @account.destroy
        render_success
      end

      private

      def create_account_params
        params.require(:account).permit(:balance, :name, :currency, :note)
      end

      def update_account_params
        params.require(:account).permit(:name, :currency, :note)
      end

      def set_account
        @account = Account.find(params[:id])
      end

      def render_404_if_hidden
        render_404 if @account.hidden?
      end
    end
  end
end
