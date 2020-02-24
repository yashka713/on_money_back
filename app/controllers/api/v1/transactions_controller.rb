module Api
  module V1
    class TransactionsController < BaseController
      load_and_authorize_resource :transaction, id_param: :id, only: :destroy_receipt

      def index
        transactions = transaction_list
                       .order('date DESC, id')
                       .page(params.dig(:page, :number) || 1)
                       .per(params.dig(:page, :size) || ENV['DEFAULT_TRANSACTIONS_AMOUNT'])

        render_success transactions
      end

      def months_list
        months = current_user.transactions.transactions_months_list

        months_list =
          {
            data: ActiveModel::Serializer::CollectionSerializer.new(months,
                                                                    serializer: MonthsListSerializer)
          }
        render_success months_list
      end

      def destroy_receipt
        @transaction.receipt = nil
        @transaction.save

        render_success @transaction
      end

      private

      def transaction_list
        list = current_user.transactions

        params[:date] ? list.created_between(params[:date][:from], params[:date][:to]) : list
      end
    end
  end
end
