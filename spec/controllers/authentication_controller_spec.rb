require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:params) { {} }
  let!(:user) { create(:user, username: 'Jason', password: 'password', password_confirmation: 'password') }

  describe 'POST sign_in' do
    before { post :sign_in, params: params }

    context 'with valid login data' do
      let(:params) { { username: 'Jason', password: 'password' } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)['token']).not_to be nil }
    end

    context 'with invalid login data' do
      let(:params) { { username: 'incorrect', password: 'incorrect' } }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE sign_out' do
    let(:token) {}

    before do
      @request.headers[I18n.t('auth')] = token
      delete :sign_out
    end

    context 'with valid token' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      it {  }
    end

    context 'with invalid token' do
      let(:token) { 'some.invalid.token' }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
