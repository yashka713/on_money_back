class TransferService < BaseService
  attr_accessor :transaction, :errors

  def initialize(transaction, params = {})
    @transaction = transaction
    @params = params
    @errors = ActiveModel::Errors.new(self)
  end

  def create
    persist_with_transaction do
      @transaction.assign_attributes(transfer_attributes)

      raise ActiveRecord::Rollback unless @transaction.save

      change_account_balance
    end
  end

  def update
    persist_with_transaction do
      # turn back old balance
      set_previous_account_balance

      # set new attributes
      @transaction.update!(transfer_attributes)

      # update accounts
      change_account_balance
    end
  end

  def destroy
    persist_with_transaction do
      @transaction.destroy

      set_previous_account_balance
    end
  end

  private

  def set_previous_account_balance
    @transaction.profitable.update!(balance: charge_balance(@transaction.profitable).to_f)
    @transaction.chargeable.update!(balance: profit_balance(@transaction.chargeable).to_f)
  end

  def change_account_balance
    @transaction.chargeable.update!(balance: charge_balance(@transaction.chargeable).to_f)
    @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
  end

  def transfer_attributes
    {
      chargeable: Account.find(@params[:from]),
      profitable: Account.find(@params[:to]),
      amount: @params[:amount],
      date: @params[:date],
      note: @params[:note]
    }
  end

  def charge_balance(account, amount = @transaction.amount)
    Money.from_amount(account.balance, account.currency) - Money.from_amount(amount, account.currency)
  end

  def profit_balance(account, amount = @transaction.amount)
    Money.from_amount(account.balance, account.currency) + Money.from_amount(amount, account.currency)
  end
end
