class ReceiptUploader < Shrine
  plugin :default_storage, store: :receipt

  def generate_location(io, record: nil, derivative: nil, **options)
    return super unless record

    user = record.user
    transaction_table  = record.class.table_name
    user_table  = user.class.table_name
    transaction_id     = record.id
    user_id     = user.id
    prefix = (derivative || "original").to_s

    filename = prefix + '-' + (io.try(:original_filename) || record.receipt.metadata["filename"])

    "#{user_table}/#{user_id}/receipts/#{transaction_table}/#{transaction_id}/#{filename}"
  end

  Attacher.derivatives_processor do |original|
    processor = ImageProcessing::MiniMagick.source(original)

    {
      thumbnail:  processor.resize_to_limit!(200, 200)
    }
  end
end
