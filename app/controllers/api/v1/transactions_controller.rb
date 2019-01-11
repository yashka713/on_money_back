module Api
  module V1
    class TransactionsController < BaseController
      def index
        transactions = current_user
                       .transactions
                       .order(date: :asc)
                       .page(params.dig(:page, :number) || 1)
                       .per(params.dig(:page, :size) || ENV['DEFAULT_TRANSACTIONS_AMOUNT'])
        render_success transactions, 200, include: { chargeable: {}, profitable: {} }
      end
    end
  end
end
