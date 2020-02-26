module Charts
  module MonthTotalChargesService
    extend self

    def call(current_user, current_month, account_ids)
      monthly_grouped_charges = current_user.transactions.monthly_grouped_charges(current_month, account_ids)

      {
        month: current_month.strftime('%B %Y'),
        data: formatize(monthly_grouped_charges)
      }
    end

    private

    def formatize(hash)
      labels = []
      datasets = []
      hash.each do |key, value|
        labels << key.first
        datasets << {
          label: key.last,
          data: value
        }
      end
      {
        labels: labels,
        datasets: datasets
      }
    end
  end
end
