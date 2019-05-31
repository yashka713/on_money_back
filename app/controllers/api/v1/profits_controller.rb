module Api
  module V1
    class ProfitsController < BaseController
      load_and_authorize_resource :transaction, id_param: :id, except: %i[index create]
      before_action :accounts_before_update, only: :update

      def index
        render_success Transaction.last_profits(current_user)
      end

      def create
        transaction = Transaction.new(user: current_user, operation_type: :profit)
        profit_service = ProfitService.new(transaction, profit_params)

        if profit_service.create
          render_success profit_service.transaction, 201
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      def show
        render_success @transaction
      end

      def update
        profit_service = ProfitService.new(@transaction, profit_params)
        if profit_service.update
          render_success profit_service.transaction, 200, old_profitable: @old_profitable
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      def destroy
        profit_service = ProfitService.new(@transaction)
        if profit_service.destroy
          render_success profit_service.transaction
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      private

      def accounts_before_update
        @old_profitable = @transaction.profitable
      end

      def profit_params
        params.require(:profit).permit(:date, :amount, :from, :to, :note, tag_ids: [])
      end
    end
  end
end
