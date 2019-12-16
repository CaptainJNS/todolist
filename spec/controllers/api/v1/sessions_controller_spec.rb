require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:params) { {} }
  let!(:user) { create(:user, username: 'Jason', password: 'password', password_confirmation: 'password') }

  describe 'POST create' do
    before { post :create, params: params }

    context 'when Success' do
      context 'with valid login data' do
        let(:params) { { username: 'Jason', password: 'password' } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(JSON.parse(response.body)['token']).not_to be nil }
      end
    end

    context 'when Failure' do
      context 'with invalid login data' do
        let(:params) { { username: 'incorrect', password: 'incorrect' } }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:token) {}

    before do
      @request.headers[I18n.t('auth')] = token
      stub_const('Constants::TOKEN_EXP_DATE', 5.minutes)
      delete :destroy
    end

    context 'when Success' do
      context 'with valid token' do
        let(:token) { JsonWebToken.encode(user_id: user.id) }

        it { expect(Rails.cache.redis.keys).to include(token) }
      end
    end

    context 'when Failure' do
      context 'with invalid token' do
        let(:token) { 'some.invalid.token' }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
  end
end
