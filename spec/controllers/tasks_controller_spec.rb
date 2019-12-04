require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:params) {}

  before { @request.headers[I18n.t('auth')] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET index' do
    context 'with valid project_id' do
      let(:params) { { project_id: project.id } }

      before do
        create_list(:task, rand(1..3), project: project)
        get :index, params: params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to match_response_schema('tasks') }
    end

    context 'with invalid project_id' do
      let(:params) { { project_id: 0 } }

      before do
        create_list(:task, rand(1..3), project: project)
        get :index, params: params
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
    end
  end

  describe 'GET show' do
    before { get :show, params: params }

    context 'with valid id' do
      let(:task) { create(:task, project: project) }
      let(:params) { { id: task.id, project_id: project.id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to match_response_schema('task') }
    end

    context 'with invalid id' do
      let(:params) { { id: 0, project_id: project.id } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end
  end

  describe 'POST create' do
    before { post :create, params: params }

    context 'with valid name' do
      let(:params) { { project_id: project.id, name: FFaker::Book.title } }

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to match_response_schema('task') }
    end

    context 'with invalid name' do
      let(:params) { { project_id: project.id, name: nil } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to match_response_schema('errors') }
    end

    context 'with invalid project_id' do
      let(:params) { { project_id: 0, name: FFaker::Book.title } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.project_not_found')) }
    end
  end

  describe 'PUT update' do
    let(:task) { create(:task, project: project) }

    before { put :update, params: params }

    context 'with valid name and deadline' do
      let(:params) { { id: task.id, name: FFaker::Lorem.word, deadline: DateTime.now + 1.day, project_id: project.id } }

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to match_response_schema('task') }
    end

    context 'with invalid name' do
      let(:params) { { id: task.id, name: nil, project_id: project.id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to match_response_schema('errors') }
    end

    context 'with past deadline' do
      let(:params) { { id: task.id, deadline: DateTime.now - 1.day, project_id: project.id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.past_deadline')) }
    end

    context 'with invalid deadline' do
      let(:params) { { id: task.id, deadline: 'not-a-date', project_id: project.id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_deadline')) }
    end

    context 'with invalid id' do
      let(:params) { { id: 0, name: FFaker::Lorem.word, project_id: project.id } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end

    context 'with valid position' do
      let(:params) { { id: task.id, position: 1, project_id: project.id } }

      before { create(:task, project: project, position: 1) }

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to match_response_schema('task') }
    end

    context 'with valid position' do
      let(:params) { { id: task.id, position: 0, project_id: project.id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.invalid_position')) }
    end

    context 'with invalid id when position update' do
      let(:params) { { id: 0, position: 0, project_id: project.id } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end
  end

  describe 'DELETE destroy' do
    let!(:task) { create(:task, project: project) }

    context 'with valid id' do
      let(:params) { { id: task.id, project_id: project.id } }

      it { expect { delete :destroy, params: params }.to change(Task, :count).by(-1) }
    end

    context 'with invalid id' do
      let(:params) { { id: 0, project_id: project.id } }

      before { delete :destroy, params: params }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end
  end

  describe 'PUT complete' do
    let(:task) { create(:task, project: project) }

    before { put :complete, params: params }

    context 'with correct id' do
      let(:params) { { id: task.id, project_id: project.id } }

      it { expect(JSON.parse(response.body)['messages']).to include(I18n.t('messages.all_tasks_complete')) }
    end

    context 'with invalid id' do
      let(:params) { { id: 0, project_id: project.id } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end
  end
end
