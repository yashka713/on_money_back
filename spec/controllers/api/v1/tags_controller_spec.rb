require 'rails_helper'

RSpec.describe Api::V1::TagsController, type: :controller do
  let!(:user) { create :user }
  let!(:tag) { create :tag, user: user }
  let!(:tag_list) do
    create_list :tag, 10,
                user: user
  end

  before { login_user(user) }

  context 'index' do
    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      it 'should be Array' do
        expect(parsed_data_from_body).to be_instance_of Array
      end

      it 'should contain all current user tags' do
        expect(parsed_data_from_body.length).to eq user.tags.length
      end

      it 'should be serialized' do
        data = parsed_data_from_body.last

        expect(tag_list.pluck(:id)).to include(data['id'].to_i)
        expect(data['type']).to eq('tags')
      end
    end
  end

  context 'create' do
    let(:new_tag_name) { 'Work' }
    let(:tag_params) { { tag: { name: new_tag_name } } }

    it 'increment tag count by 1' do
      expect do
        post :create, params: tag_params
      end.to change { Tag.count }.by(1)
    end

    context 'response' do
      before { post :create, params: tag_params }

      it 'responds with 201' do
        expect(response).to have_http_status(:ok)
      end

      it 'response attributes should be serialized' do
        tag = parsed_data_from_body

        expect(tag['type']).to eq('tags')
        expect(tag['attributes']).to include('name')
        expect(tag['attributes']['name']).to eq(new_tag_name)
      end
    end
  end

  context 'show' do
    before { get :show, params: { id: tag.id } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(tag.id.to_s)
      expect(data['type']).to eq('tags')
      expect(data['attributes']['name']).to eq(tag.name)
    end
  end

  context 'update' do
    let(:new_name) { 'new_tag_name' }
    let(:update_params) { { name: new_name } }

    before { patch :update, params: { id: tag.id, tag: update_params } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(tag.id.to_s)
      expect(data['type']).to eq('tags')
      expect(data['attributes']['name']).to eq(new_name)
    end
  end

  context 'destroy' do
    it 'should responds with ok' do
      delete :destroy, params: { id: tag.id }

      expect(response).to have_http_status(:ok)
    end

    it 'decrement tags count by 1' do
      expect do
        delete :destroy, params: { id: tag.id }
      end.to change { user.tags.size }.by(-1)
    end
  end
end
