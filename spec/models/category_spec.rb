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

  context 'max_category_amount' do
    let!(:user) { create(:user) }

    let!(:profits_categories_list) { create_list :category, 11, type_of: 'profit', user: user }
    let!(:charges_categories_list) { create_list :category, 11, type_of: 'charge', user: user }
    let!(:category_params) { create_list :category, 10, type_of: 'charge' }

    Category::TYPES.each do |type|
      it "should return error when max amount of #{type}es reached" do
        category = Category.create(user: user, name: 'test', type_of: type)
        expect(full_messages(category)).to match(/#{I18n.t('category.errors.max_amount_riched')}/)
      end
    end
  end
end
