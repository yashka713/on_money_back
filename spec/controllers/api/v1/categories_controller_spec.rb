require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  let!(:user) { create :user }
  let!(:category) { create :category, user: user, type_of: 'charge' }

  before { login_user(user) }

  context 'index' do
    let!(:charges) { create_list :category, 5, user: user, type_of: 'charge' }
    let!(:profits) { create_list :category, 5, user: user, type_of: 'profit' }

    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    it 'should be Array' do
      expect(parsed_data_from_body).to be_instance_of Array
    end

    context 'request' do
      context 'without params' do
        it 'should define length of responce' do
          expect(parsed_data_from_body.length).to eq(user.categories.length)
        end
      end

      context 'with params' do
        before { get :index, params: { type_of: 'charges_categories' } }

        it 'should define length of responce' do
          expect(parsed_data_from_body.length).to eq(Category.charges_categories(user).length)
        end
      end
    end

    context 'response attributes' do
      it 'should be serialized' do
        data = parsed_data_from_body.first

        expect(data['type']).to eq('categories')
        expect(data['attributes']).to include('name')
        expect(data['attributes']).to include('note')
        expect(data['attributes']).to include('type_of')
        expect(Category::TYPES).to include(data['attributes']['type_of'])
      end
    end
  end

  context 'create' do
    let(:category_params) { FactoryBot.attributes_for(:category, name: 'new category', type_of: 'profit') }

    it 'increment account count by 1' do
      expect do
        post :create, params: { category: category_params }
      end.to change { Category.count }.by(1)
    end

    context 'response' do
      before { post :create, params: { category: category_params } }

      it 'responds with 201' do
        expect(response).to have_http_status(:created)
      end

      it 'response attributes should be serialized' do
        data = parsed_data_from_body

        expect(data['type']).to eq('categories')
        expect(data['attributes']['name']).to eq(category_params[:name])
        expect(data['attributes']['type_of']).to eq(category_params[:type_of])
      end
    end

    context 'invalid' do
      let(:invalid_name) { ('a'..'z').to_a.join }
      let(:invalid_params) { FactoryBot.attributes_for(:category, name: invalid_name, type_of: 'profit') }

      it 'should respond with unprocessable_entity' do
        post :create, params: { category: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'show' do
    before { get :show, params: { id: category.id } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(category.id.to_s)
      expect(data['type']).to eq('categories')
      expect(data['attributes']['name']).to eq(category.name)
      expect(data['attributes']['type_of']).to eq(category.type_of)
      expect(data['attributes']['note']).to eq(category.note)
    end
  end

  context 'update' do
    let(:new_name) { 'new_test_name' }
    let(:update_params) { { name: new_name } }

    before { patch :update, params: { id: category.id, category: update_params } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(category.id.to_s)
      expect(data['type']).to eq('categories')
      expect(data['attributes']['name']).to eq(new_name)
      expect(data['attributes']['type_of']).to eq(category.type_of)
      expect(data['attributes']['note']).to eq(category.note)
    end
  end

  context 'types' do
    before { get :types }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return serialized category types' do
      data = parsed_data_from_body.first

      expect(Category::TYPES).to include(data['id'])
      expect(data['type']).to eq('category_type')
      expect(data['attributes']).to eq({})
    end
  end

  context 'destroy' do
    context 'responce' do
      it 'should responds with ok' do
        delete :destroy, params: { id: category.id, type: 'hide' }

        expect(response).to have_http_status(:ok)
      end
    end

    it 'should not change Categories count' do
      expect do
        delete :destroy, params: { id: category.id, type: 'hide' }
      end.not_to change(Category, :count)
    end
  end
end
