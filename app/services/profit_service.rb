class ProfitService < BaseService
  attr_accessor :transaction, :errors

  include MoneyOperationable

  def initialize(transaction, params = {})
    @transaction = transaction
    @params = params

    @chargeable = Category.find_by(id: @params[:from]) || @transaction.chargeable
    @profitable = Account.find_by(id: @params[:to]) || @transaction.profitable

    @errors = ActiveModel::Errors.new(self)
  end

  def create
    persist_with_transaction do
      @transaction.assign_attributes(profit_attributes)

      raise ActiveRecord::Rollback unless @transaction.save

      @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
    end
  end

  def update
    persist_with_transaction do
      @transaction.profitable.update!(balance: charge_balance(@transaction.profitable).to_f)

      raise ActiveRecord::Rollback unless @transaction.update!(profit_attributes)

      @transaction.profitable.update!(balance: profit_balance(@transaction.profitable).to_f)
    end
  end

  def destroy
    persist_with_transaction do
      @transaction.destroy

      @transaction.profitable.update!(balance: charge_balance(@transaction.profitable, @transaction.to_amount).to_f)
    end
  end

  private

  def profit_attributes
    {
      chargeable: @chargeable,
      profitable: @profitable,
      from_amount: @params[:amount] || @transaction.from_amount,
      to_amount: @params[:amount] || @transaction.to_amount,
      date: @params[:date] || @transaction.date,
      note: @params[:note] || @transaction.note
    }
  end
end
