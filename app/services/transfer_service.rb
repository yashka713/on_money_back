class TransferService < BaseService
  def create
    persist_with_transaction do
      @transaction.assign_attributes(transaction_attributes)

      raise ActiveRecord::Rollback unless @transaction.save

      change_account_balance
    end
  end

  def update
    persist_with_transaction do
      # turn back old balance
      set_previous_account_balance

      # set new attributes
      raise ActiveRecord::Rollback unless @transaction.update!(transaction_attributes)

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
    @transaction.profitable.update!(balance: charge_balance(@transaction.profitable, @transaction.to_amount).to_f)
    @transaction.chargeable.update!(balance: profit_balance(@transaction.chargeable, @transaction.from_amount).to_f)
  end

  def change_account_balance
    @transaction.chargeable.update!(balance: charge_balance(@transaction.chargeable).to_f)
    @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
  end

  def transaction_attributes
    super.merge(to_amount: rateable_amount)
  end

  def rateable_amount
    return @params[:amount] if currencies_the_same?
    return (@params[:amount].to_f * @params[:rate].to_f) if !currencies_the_same? && valid_rate?

    empty_rate_error
  end

  def empty_rate_error
    @transaction.errors[:base] << I18n.t('account.errors.rate.empty')
    raise ActiveRecord::Rollback
  end

  def valid_rate?
    @params.include?(:rate) && !@params[:rate].try(:zero?)
  end

  def currencies_the_same?
    @chargeable.currency == @profitable.currency
  end
end
