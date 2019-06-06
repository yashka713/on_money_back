Transaction.all.map do |transaction|
  TransactionTag.create!(
    money_transaction: transaction,
    tag: Tag.all.sample
  )
end

puts 'TransactionTag successfully created'
