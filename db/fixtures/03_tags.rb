TAG_NAMES = %w[
  2019
  Sport\ club
  Daily
  Cinema
  Work
  Dating
  Internet
  Books
  Vacation
  Weekend
  Pharmacy
  Pub
  Credit
  Bus
  Underground
].freeze

TAG_NAMES.map { |name| Tag.create!(user_id: 1, name: name) }

puts 'Tags successfully added'
