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

    describe 'Success' do
      context 'with valid id' do
        let(:project) { create(:project, user: user) }
        let(:params) { { id: project.id } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('project') }
      end
    end

    describe 'Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'POST create' do
    before { post :create, params: params }

    describe 'Success' do
      context 'with valid name' do
        let(:params) { { name: FFaker::Book.title } }

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('project') }
      end
    end

    describe 'Failure' do
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
    let(:params) { { id: project_id, name: name } }
    let(:project_id) { project.id }
    let(:name) { FFaker::Lorem.word }

    before { put :update, params: params }

    describe 'Success' do
      context 'with valid name' do
        it { expect(response).to have_http_status(:ok) }
      end
    end

    describe 'Failure' do
      context 'with invalid name' do
        let(:name) { nil }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end

      context 'with existing name' do
        let(:name) { project.name }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_exist')) }
      end

      context 'with invalid id' do
        let(:project_id) { 0 }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:project) { create(:project, user: user) }

    describe 'Success' do
      context 'with valid id' do
        let(:params) { { id: project.id } }

        it { expect { delete :destroy, params: params }.to change(Project, :count).by(-1) }
      end
    end

    describe 'Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        before { delete :destroy, params: params }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end
end
