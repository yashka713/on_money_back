module Charts
  module MonthTotalService
    extend self

    def call(hash)
      formatize(hash)
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
