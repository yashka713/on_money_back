module Api
  module V1
    class ChargesController < BaseController
      load_and_authorize_resource :transaction, id_param: :id, except: %i[index create]

      def index
        render_success Transaction.last_charges(current_user), 200, include: { chargeable: {}, profitable: {} }
      end

      def create
        transaction = Transaction.new(user: current_user, operation_type: :charge)
        charge_service = ChargeService.new(transaction, charge_params)

        if charge_service.create
          render_success charge_service.transaction, 201, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors charge_service.transaction
        end
      end

      def show
        render_success @transaction, 200, include: { chargeable: {}, profitable: {} }
      end

      def update
        charge_service = ChargeService.new(@transaction, charge_params)
        if charge_service.update
          render_success charge_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors charge_service.transaction
        end
      end

      def destroy
        charge_service = ChargeService.new(@transaction)
        if charge_service.destroy
          render_success charge_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors charge_service.transaction
        end
      end

      private

      def charge_params
        params.require(:charge).permit(:date, :amount, :from, :to, :note)
      end
    end
  end
end
