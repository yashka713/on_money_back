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

      def months_list
        months = current_user.transactions.pluck(:date).group_by(&:beginning_of_month).keys

        months_list =
          {
            data: ActiveModel::Serializer::CollectionSerializer.new(months,
                                                                    serializer: MonthsListSerializer)
          }
        render_success months_list
      end

      private

      def transaction_list
        list = current_user.transactions

        params[:date] ? list.created_between(params[:date][:from], params[:date][:to]) : list
      end
    end
  end
end
