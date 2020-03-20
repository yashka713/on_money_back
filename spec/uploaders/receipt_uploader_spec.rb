RSpec.describe ReceiptUploader do
  let!(:user) { create(:user) }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:chargeable) { create :category, user_id: user.id, type_of: 'profit' }

  let!(:profit) do
    create :profit, chargeable: chargeable, profitable: profitable, user: user, from_amount: 100, to_amount: 100
  end

  let(:filename) { 'receipt.jpg' }

  let(:receipt) do
    Receipt.create(
      receipt: File.open("spec/fixtures/#{filename}", 'rb'),
      money_transaction: profit
    )
  end
  let(:receipt_data) { receipt.receipt }
  let(:derivatives) { receipt.receipt_derivatives }

  it 'extracts metadata' do
    file_id = "users/#{user.id}/transactions/#{profit.id}/original-#{filename}"

    expect(receipt_data.mime_type).to eq('image/jpeg')
    expect(receipt_data.extension).to eq('jpg')

    expect(receipt_data.size).to be_instance_of(Integer)

    expect(receipt_data.original_filename).to eq(filename)

    expect(receipt_data.storage_key).to eq(:receipt)

    expect(receipt_data.uploader).to be_instance_of(ReceiptUploader)

    expect(receipt_data.id).to eq(file_id)
  end

  it 'generates derivatives' do
    file_id = "users/#{user.id}/transactions/#{profit.id}/thumbnail-#{filename}"

    expect(derivatives).to include(:thumbnail)

    expect(derivatives[:thumbnail]).to be_kind_of(Shrine::UploadedFile)

    expect(derivatives[:thumbnail].mime_type).to eq('image/jpeg')
    expect(derivatives[:thumbnail].extension).to eq('jpg')

    expect(derivatives[:thumbnail].id).to eq(file_id)
  end
end
