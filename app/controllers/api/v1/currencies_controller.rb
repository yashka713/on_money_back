module Api
  module V1
    class CurrenciesController < BaseController
      def index
        currencies =
          {
            data: ActiveModel::Serializer::CollectionSerializer.new(Money::Currency.all,
                                                                    serializer: CurrenciesSerializer)
          }
        render_success currencies
      end
    end
  end
end
