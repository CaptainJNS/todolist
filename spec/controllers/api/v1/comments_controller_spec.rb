require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user, :with_task) }
  let(:task) { user.tasks.first }
  let(:params) {}

  before { @request.headers[I18n.t('auth')] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET index' do
    describe 'Success' do
      context 'with valid task_id' do
        let(:params) { { task_id: task.id } }

        before do
          create(:comment, task: task)
          get :index, params: params
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to match_response_schema('comments') }
      end
    end

    describe 'Failure' do
      context 'with invalid task_id' do
        let(:params) { { task_id: 0 } }

        before { get :index, params: params }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
      end
    end
  end

  describe 'POST create' do
    before { |example| post :create, params: params unless example.metadata[:skip_before] }

    describe 'Success' do
      context 'with valid body' do
        let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph } }

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('comment') }
      end

      context 'with valid image' do
        let(:image) { fixture_file_upload('image.png') }
        let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph, image: image } }

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('comment') }
        it { expect(task.comments.last.image.attached?).to be true }
      end
    end

    describe 'Failure' do
      context 'with invalid body' do
        let(:params) { { task_id: task.id, body: nil } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end

      context 'with invalid task_id' do
        let(:params) { { task_id: 0, body: FFaker::Book.title } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
      end

      context 'with invalid image size', skip_before: true do
        let(:image) { fixture_file_upload('image.png') }
        let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph, image: image } }

        before do
          stub_const('Constants::IMAGE_MAX_SIZE', 0)
          post :create, params: params
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end

      context 'with invalid image type', skip_before: true do
        let(:image) { fixture_file_upload('image.png') }
        let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph, image: image } }

        before do
          stub_const('Constants::PERMITTED_IMAGE_TYPES', [])
          post :create, params: params
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:comment) { create(:comment, task: task) }

    describe 'Success' do
      context 'with valid id' do
        let(:params) { { id: comment.id } }

        it { expect { delete :destroy, params: params }.to change(Comment, :count).by(-1) }
      end
    end

    describe 'Failure' do
      context 'with invalid id' do
        let(:params) { { id: 0 } }

        before { delete :destroy, params: params }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.comment_not_found')) }
      end
    end
  end
end
