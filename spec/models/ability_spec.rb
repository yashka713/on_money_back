require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:owner) { create :user }
  let(:user) { create :user }
  let(:account_one) { create :account, user: owner }
  let(:account_two) { create :account, user: owner }
  let(:category) { create :category, user: owner }
  let(:profit) { create :profit, user: owner, chargeable: category, profitable: account_two }
  let(:transfer) { create :transfer, user: owner, chargeable: account_one, profitable: account_two }

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

      it { subject.can?(:update, category) }
      it { subject.can?(:show, category) }
      it { subject.can?(:destroy, category) }
    end

    context 'any other user' do
      subject(:ability) { Ability.new(user) }

      it { subject.can?(:create, category) }
      it { subject.can?(:index, category) }

      it { subject.cannot?(:update, category) }
      it { subject.cannot?(:show, category) }
      it { subject.cannot?(:destroy, category) }
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
end
