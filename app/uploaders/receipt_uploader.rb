class ReceiptUploader < Shrine
  plugin :default_storage, store: :receipt

  # rubocop:disable Metrics/AbcSize
  def generate_location(io, record: nil, derivative: nil)
    return super unless record.try(:id)

    user = record.user
    user_table  = user.class.table_name
    user_id     = user.id
    transaction = record.money_transaction
    transaction_table  = transaction.class.table_name
    transaction_id     = transaction.id
    prefix = (derivative || 'original').to_s

    filename = prefix + '-' + (io.try(:original_filename) || record.receipt.metadata['filename'])

    "#{user_table}/#{user_id}/#{transaction_table}/#{transaction_id}/#{filename}"
  end

  Attacher.derivatives_processor do |original|
    processor = ImageProcessing::MiniMagick.source(original)

    {
      thumbnail: processor.resize_to_limit!(200, 200)
    }
  end
  # rubocop:enable Metrics/AbcSize
end
