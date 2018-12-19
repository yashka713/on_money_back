module Api
  module V1
    class ProfitsController < BaseController
      load_and_authorize_resource :transaction, id_param: :id, except: %i[index create]

      def index
        render_success Transaction.last_profits(current_user), 200, include: { chargeable: {}, profitable: {} }
      end

      def create
        transaction = Transaction.new(user: current_user, operation_type: :profit)
        profit_service = ProfitService.new(transaction, profit_params)

        if profit_service.create
          render_success profit_service.transaction, 201, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      def show
        render_success @transaction, 200, include: { chargeable: {}, profitable: {} }
      end

      def update
        profit_service = ProfitService.new(@transaction, profit_params)
        if profit_service.update
          render_success profit_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      def destroy
        profit_service = ProfitService.new(@transaction)
        if profit_service.destroy
          render_success profit_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors profit_service.transaction
        end
      end

      private

      def profit_params
        params.require(:profit).permit(:date, :amount, :from, :to, :note)
      end
    end
  end
end