class ChargeService < BaseService
  def create
    persist_with_transaction do
      @transaction.assign_attributes(transaction_attributes)

      raise ActiveRecord::Rollback unless @transaction.save

      @transaction.chargeable.update!(balance: charge_balance(@transaction.chargeable).to_f)
    end
  end

  def update
    persist_with_transaction do
      @transaction.chargeable.update!(balance: profit_balance(@transaction.chargeable).to_f)

      raise ActiveRecord::Rollback unless @transaction.update!(transaction_attributes)

      @transaction.chargeable.update!(balance: charge_balance(@transaction.chargeable).to_f)
    end
  end

  def destroy
    persist_with_transaction do
      @transaction.destroy

      @transaction.chargeable.update!(balance: profit_balance(@transaction.chargeable, @transaction.from_amount).to_f)
    end
  end
end
