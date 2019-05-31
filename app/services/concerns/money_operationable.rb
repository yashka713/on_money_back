module MoneyOperationable
  extend ActiveSupport::Concern

  private

  def charge_balance(account, amount = @transaction.from_amount)
    Money.from_amount(account.balance, account.currency) - Money.from_amount(amount, account.currency)
  end

  def profit_balance(account, amount = @transaction.to_amount)
    Money.from_amount(account.balance, account.currency) + Money.from_amount(amount, account.currency)
  end
end
