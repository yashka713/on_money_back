require 'rails_helper'

RSpec.describe CategoryDestroyerService do
  let(:user) { create(:user) }
  let!(:category) { create(:category, user: user) }

  let(:destroy_params) { { type: 'hide' } }

  context 'destroy, when type is "hide"' do
    let(:service) { CategoryDestroyerService.new(category, destroy_params) }

    it 'should not change Category count' do
      expect do
        service.destroy
      end.not_to change(Category, :count)
    end

    it 'should hide Category' do
      expect do
        service.destroy
        category.reload
      end.to change { category.status }.from('active').to('hidden')
    end
  end
end
