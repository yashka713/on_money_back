module Api
  module V1
    class ReceiptsController < BaseController
      load_and_authorize_resource :transaction, id_param: :transaction_id, only: :destroy

      before_action :check_receipt, only: :destroy

      def destroy
        return render_success(@transaction.reload, 200) if @transaction.receipt.destroy

        render_jsonapi_errors @transaction.receipt
      end

      private

      def check_receipt
        render_404 unless @transaction.receipt
      end
    end
  end
end
