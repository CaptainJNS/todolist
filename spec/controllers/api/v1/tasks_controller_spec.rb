require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user, :with_project) }
  let(:project) { user.projects.first }
  let(:params) {}

  before { @request.headers[I18n.t('auth')] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET index' do
    describe 'Success' do
      context 'with valid project_id' do
        let(:params) { { project_id: project.id } }

        before do
          create(:task, project: project)
          get :index, params: params
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('tasks') }
      end
    end

    describe 'Failure' do
      context 'with invalid project_id' do
        let(:params) { { project_id: 0 } }

        before { get :index, params: params }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'GET show' do
    before { get :show, params: params }

    describe 'Success' do
      context 'with valid id' do
        let(:task) { create(:task, project: project) }
        let(:params) { { id: task.id } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('task') }
      end
    end

    describe 'Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
      end
    end
  end

  describe 'POST create' do
    let(:params) { { project_id: project_id, name: name } }
    let(:name) { FFaker::Book.title }
    let(:project_id) { project.id }

    before { post :create, params: params }

    describe 'Success' do
      context 'with valid name' do
        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('task') }
      end
    end

    describe 'Failure' do
      context 'with invalid name' do
        let(:name) { nil }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end

      context 'with invalid project_id' do
        let(:project_id) { 0 }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
      end
    end
  end

  describe 'PUT update' do
    let(:task) { create(:task, project: project) }

    before { put :update, params: params }

    describe 'Success' do
      context 'with valid name and deadline' do
        let(:params) { { id: task.id, name: FFaker::Lorem.word, deadline: DateTime.now + 1.day } }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'with valid position' do
        let(:params) { { id: task.id, position: 1 } }

        before { create(:task, project: project, position: 1) }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'with valid done parameter' do
        let(:params) { { id: task.id, done: true } }

        it { expect(response).to have_http_status(:ok) }
      end
    end

    describe 'Failure' do
      context 'with invalid name' do
        let(:params) { { id: task.id, name: nil } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end

      context 'with past deadline' do
        let(:params) { { id: task.id, deadline: DateTime.now - 1.day } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.past_deadline')) }
      end

      context 'with invalid deadline' do
        let(:params) { { id: task.id, deadline: 'not-a-date' } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_deadline')) }
      end

      context 'with invalid id' do
        let(:params) { { id: 0, name: FFaker::Lorem.word } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
      end

      context 'with zero position' do
        let(:params) { { id: task.id, position: 0 } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_position')) }
      end

      context 'with negative position' do
        let(:params) { { id: task.id, position: -1 } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_position')) }
      end

      context 'with too big position' do
        let(:params) { { id: task.id, position: project.tasks.count.next } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_position')) }
      end

      context 'with no number position' do
        let(:params) { { id: task.id, position: 'bla-bla-bla' } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_position')) }
      end

      context 'with invalid done parameter' do
        let(:params) { { id: task.id, done: 'bla-bla-bla' } }

        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_done')) }
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:task) { create(:task, project: project) }

    describe 'Success' do
      context 'with valid id' do
        let(:params) { { id: task.id } }

        it { expect { delete :destroy, params: params }.to change(Task, :count).by(-1) }
      end
    end

    describe 'Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        before { delete :destroy, params: params }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
      end
    end
  end
end
