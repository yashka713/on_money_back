class BaseService
  attr_accessor :transaction, :errors

  include MoneyOperationable

  def initialize(transaction, params = {})
    @transaction = transaction
    @params = params

    set_attributes_for_operation!

    @errors = ActiveModel::Errors.new(self)

    raise ActiveRecord::RecordNotFound if @chargeable.nil? || @profitable.nil?
  end

  private

  def set_attributes_for_operation!
    case @transaction.operation_type
    when 'transfer'
      attributes_for_transfer
    when 'profit'
      attributes_for_profit
    when 'charge'
      attributes_for_charge
    else
      @transaction.errors[:base] << I18n.t('transactions.errors.unknown_operation_type')
    end
  end

  def copy_errors(errors)
    errors.each { |key, value| @errors.add key, value }
  end

  def persist_with_transaction
    ActiveRecord::Base.transaction do
      return yield
    rescue ActiveRecord::RecordInvalid => exception
      copy_errors exception.record.errors
      raise ActiveRecord::Rollback
    end

    false
  end

  def attributes_for_transfer
    @chargeable = Account.find_by(id: @params[:from]) || @transaction.chargeable
    @profitable = Account.find_by(id: @params[:to]) || @transaction.profitable
  end

  def attributes_for_profit
    @chargeable = Category.find_by(id: @params[:from]) || @transaction.chargeable
    @profitable = Account.find_by(id: @params[:to]) || @transaction.profitable
  end

  def attributes_for_charge
    @chargeable = Account.find_by(id: @params[:from]) || @transaction.chargeable
    @profitable = Category.find_by(id: @params[:to]) || @transaction.profitable
  end

  def transaction_attributes
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
