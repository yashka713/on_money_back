require 'rails_helper'

RSpec.describe TransactionTag, type: :model do
  it { should belong_to(:money_transaction).class_name('Transaction').optional }
  it { should belong_to(:tag).optional }
end
