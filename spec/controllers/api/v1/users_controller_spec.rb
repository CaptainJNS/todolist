require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST create' do
    let(:params) { {} }

    before { post :create, params: params }

    context 'Success' do
      context 'with valid register data' do
        let(:params) { { username: 'Jason', password: 'password', password_confirmation: 'password' } }

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to match_response_schema('user') }
      end
    end

    context 'Failure' do
      context 'with invalid register data' do
        let(:params) { { username: '', password: 'pass', password_confirmation: 'word' } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response).to match_response_schema('errors') }
      end
    end
  end
end
