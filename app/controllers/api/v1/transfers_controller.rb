module Api
  module V1
    class TransfersController < BaseController
      load_and_authorize_resource :transaction, id_param: :id, except: %i[index create]
      before_action :accounts_before_update, only: :update

      def index
        render_success Transaction.last_transfers(current_user)
      end

      def create
        transaction = Transaction.new(user: current_user, operation_type: :transfer)
        transfer_service = TransferService.new(transaction, transfer_params)

        if transfer_service.create
          render_success transfer_service.transaction, 201
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      def show
        render_success @transaction
      end

      def update
        transfer_service = TransferService.new(@transaction, transfer_params)
        if transfer_service.update
          render_success transfer_service.transaction, 200,
                         old_chargeable: @old_chargeable,
                         old_profitable: @old_profitable
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      def destroy
        transfer_service = TransferService.new(@transaction)
        if transfer_service.destroy
          render_success transfer_service.transaction
        else
          render_jsonapi_errors transfer_service.transaction
        end
      end

      private

      def accounts_before_update
        @old_chargeable = @transaction.chargeable
        @old_profitable = @transaction.profitable
      end

      def transfer_params
        params.require(:transfer).permit(:date, :amount, :from, :to, :note, :rate)
      end
    end
  end
end
