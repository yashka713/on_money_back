class BaseService
  private

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
end
