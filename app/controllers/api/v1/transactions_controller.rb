module Api
  module V1
    class TransactionsController < BaseController
      def index
        transactions = transaction_list
                       .order('date DESC, id')
                       .page(params.dig(:page, :number) || 1)
                       .per(params.dig(:page, :size) || ENV['DEFAULT_TRANSACTIONS_AMOUNT'])

        render_success transactions
      end

      private

      def transaction_list
        list = current_user.transactions

        params[:date] ? list.created_between(params[:date][:from], params[:date][:to]) : list
      end
    end
  end
end
