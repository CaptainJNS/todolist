require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:params) {}

  before { @request.headers[I18n.t('auth')] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET index' do
    before do
      create_list(:project, rand(1..3), user: user)
      get :index
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to match_response_schema('projects') }
  end

  describe 'GET show' do
    before { get :show, params: params }

    context 'when Success' do
      context 'with valid id' do
        let(:project) { create(:project, user: user) }
        let(:params) { { id: project.id } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('project') }
      end
    end

    context 'when Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'POST create' do
    before { post :create, params: params }

    context 'when Success' do
      context 'with valid name' do
        let(:params) { { name: FFaker::Book.title } }

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('project') }
      end
    end

    context 'when Failure' do
      context 'with invalid name' do
        let(:params) { { name: nil } }
  
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end
  
      context 'with existing name' do
        let(:project) { create(:project, user: user) }
        let(:params) { { name: project.name } }
  
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_exist')) }
      end
    end
  end

  describe 'PUT update' do
    let(:project) { create(:project, user: user) }

    before { put :update, params: params }

    context 'when Success' do
      context 'with valid name' do
        let(:params) { { id: project.id, name: FFaker::Lorem.word } }
  
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('project') }
      end
    end

    context 'when Failure' do
      context 'with invalid name' do
        let(:params) { { id: project.id, name: nil } }
  
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end
  
      context 'with existing name' do
        let(:params) { { id: project.id, name: project.name } }
  
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_exist')) }
      end
  
      context 'with invalid id' do
        let(:params) { { id: 0, name: FFaker::Lorem.word } }
  
        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:project) { create(:project, user: user) }

    context 'when Success' do
      context 'with valid id' do
        let(:params) { { id: project.id } }
  
        it { expect { delete :destroy, params: params }.to change(Project, :count).by(-1) }
      end
    end

    context 'when Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }
  
        before { delete :destroy, params: params }
  
        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end
end
