module Api
  module V1
    class ReceiptsController < BaseController
      load_and_authorize_resource :transaction, id_param: :transaction_id, only: :destroy

      def destroy
        return render_success({}, 200) if @transaction.receipt.destroy

        render_jsonapi_errors @transaction.receipt
      end
    end
  end
end
