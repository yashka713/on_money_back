module Api
  module V1
    class TransfersController < BaseController
      before_action :set_transaction, only: %i[show update destroy]

      def index
        render_success Transaction.last_transfers(current_user), 200, include: { chargeable: {}, profitable: {} }
      end

      def create
        transaction = Transaction.new(user: current_user, operation_type: :transfer)
        transfer_service = TransferService.new(transaction, transfer_params)

        if transfer_service.create
          render_success transfer_service.transaction, 201, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      def show
        render_success @transaction, 200, include: { chargeable: {}, profitable: {} }
      end

      def update
        transfer_service = TransferService.new(@transaction, transfer_params)
        if transfer_service.update
          render_success transfer_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      def destroy
        transfer_service = TransferService.new(@transaction)
        if transfer_service.destroy
          render_success transfer_service.transaction, 200, include: { chargeable: {}, profitable: {} }
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      private

      def transfer_params
        params.require(:transfer).permit(:date, :amount, :from, :to, :note, :rate)
      end

      def set_transaction
        @transaction = Transaction.find(params[:id])
      end
    end
  end
end
