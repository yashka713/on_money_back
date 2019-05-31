class ProfitService < BaseService
  def create
    persist_with_transaction do
      @transaction.assign_attributes(transaction_attributes)

      raise ActiveRecord::Rollback unless @transaction.save

      @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
    end
  end

  def update
    persist_with_transaction do
      @transaction.profitable.update!(balance: charge_balance(@transaction.profitable).to_f)

      raise ActiveRecord::Rollback unless @transaction.update!(transaction_attributes)

      @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
    end
  end

  def destroy
    persist_with_transaction do
      @transaction.destroy

      @transaction.profitable.update!(balance: charge_balance(@transaction.profitable, @transaction.to_amount).to_f)
    end
  end
end
