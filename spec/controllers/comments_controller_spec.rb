require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:task) { create(:task) }
  let(:params) {}

  before { @request.headers[I18n.t('auth')] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET index' do
    context 'with valid task_id' do
      let(:params) { { task_id: task.id } }

      before do
        create_list(:comment, rand(1..3), task: task)
        get :index, params: params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to match_response_schema('comments') }
    end

    context 'with invalid task_id' do
      let(:params) { { task_id: 0 } }

      before do
        create_list(:comment, rand(1..3), task: task)
        get :index, params: params
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.task_not_found')) }
    end
  end

  describe 'POST create' do
    before { post :create, params: params }

    context 'with valid body' do
      let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph } }

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to match_response_schema('comment') }
    end

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

    context 'with valid image' do
      let(:image) { fixture_file_upload('image.png') }
      let(:params) { { task_id: task.id, body: FFaker::Lorem.paragraph, image: image } }

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to match_response_schema('comment') }
      it { expect(task.comments.last.image.attached?).to be true }
    end
  end

  describe 'DELETE destroy' do
    let!(:comment) { create(:comment, task: task) }

    context 'with valid id' do
      let(:params) { { id: comment.id } }

      it { expect { delete :destroy, params: params }.to change(Comment, :count).by(-1) }
    end

    context 'with invalid id' do
      let(:params) { { id: 0 } }

      before { delete :destroy, params: params }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors']).to include(I18n.t('errors.comment_not_found')) }
    end
  end
end
