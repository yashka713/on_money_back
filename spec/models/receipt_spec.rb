require 'rails_helper'

RSpec.describe Receipt, type: :model do
  it { should belong_to(:money_transaction).class_name('Transaction').optional }
  it { should have_one(:user).through(:money_transaction) }
end
