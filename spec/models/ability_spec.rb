require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:owner) { create :user }
  let(:user) { create :user }
  let(:account_one) { create :account, user: owner }
  let(:account_two) { create :account, user: owner }
  let(:category_charge) { create :category, user_id: owner.id, type_of: 'charge' }
  let(:category_profit) { create :category, user_id: owner.id, type_of: 'profit' }

  let(:transfer) { create :transfer, user: owner, chargeable: account_one, profitable: account_two }
  let(:profit) { create :profit, user: owner, chargeable: category_profit, profitable: account_two }
  let(:charge) { create :charge, user: owner, chargeable: account_one, profitable: category_charge }
  let(:tag) { create :tag, user: owner }

  context 'for account,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, account_one) }
      it { subject.can?(:show, account_one) }
      it { subject.can?(:destroy, account_one) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, account_one) }
      it { subject.can?(:index, account_one) }

      it { subject.cannot?(:update, account_one) }
      it { subject.cannot?(:show, account_one) }
      it { subject.cannot?(:destroy, account_one) }
    end
  end

  context 'for category,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, category_charge) }
      it { subject.can?(:show, category_charge) }
      it { subject.can?(:destroy, category_charge) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, category_charge) }
      it { subject.can?(:index, category_charge) }

      it { subject.cannot?(:update, category_charge) }
      it { subject.cannot?(:show, category_charge) }
      it { subject.cannot?(:destroy, category_charge) }
    end
  end

  context 'for transfer,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, transfer) }
      it { subject.can?(:show, transfer) }
      it { subject.can?(:destroy, transfer) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, transfer) }
      it { subject.can?(:index, transfer) }

      it { subject.cannot?(:update, transfer) }
      it { subject.cannot?(:show, transfer) }
      it { subject.cannot?(:destroy, transfer) }
    end
  end

  context 'for profit,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, profit) }
      it { subject.can?(:show, profit) }
      it { subject.can?(:destroy, profit) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, profit) }
      it { subject.can?(:index, profit) }

      it { subject.cannot?(:update, profit) }
      it { subject.cannot?(:show, profit) }
      it { subject.cannot?(:destroy, profit) }
    end
  end

  context 'for charge,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, charge) }
      it { subject.can?(:show, charge) }
      it { subject.can?(:destroy, charge) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, charge) }
      it { subject.can?(:index, charge) }

      it { subject.cannot?(:update, charge) }
      it { subject.cannot?(:show, charge) }
      it { subject.cannot?(:destroy, charge) }
    end
  end

  context 'for tag,' do
    context 'owner' do
      subject(:ability) { Ability.new(owner) }

      it { subject.can?(:update, tag) }
      it { subject.can?(:show, tag) }
      it { subject.can?(:destroy, tag) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, tag) }
      it { subject.can?(:index, tag) }

      it { subject.cannot?(:update, tag) }
      it { subject.cannot?(:show, tag) }
      it { subject.cannot?(:destroy, tag) }
    end
  end
end
