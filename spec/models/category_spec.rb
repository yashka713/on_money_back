require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category) { create :category }

  it { should define_enum_for(:type_of).with_values(Category::TYPES) }
  it { should define_enum_for(:status).with_values(Category::STATUSES) }

  it { should belong_to(:user) }

  it { should validate_length_of(:name).is_at_most(25) }
  it { should validate_presence_of(:name) }

  it { should validate_length_of(:note).is_at_most(100) }
  it { is_expected.to allow_value(nil).for(:note) }

  it { should validate_presence_of(:type_of) }
  it { should validate_presence_of(:status) }

  context 'destroy' do
    let(:params) { { type: 'hide' } }

    it 'shod call CategoryDestroyerService' do
      expect(CategoryDestroyerService).to receive(:new).with(category, params).and_call_original

      category.destroy(params)
    end
  end

  context 'type_not_changeable' do
    it 'should not be valid' do
      expect(category.update(type_of: (Category::TYPES - [category.type_of]).first)).to be_falsey
    end

    it 'returns error' do
      category.update(type_of: (Category::TYPES - [category.type_of]).first)
      expect(full_messages(category)).to match(/#{I18n.t('category.errors.type_changed')}/)
    end
  end
end
