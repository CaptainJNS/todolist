class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  resource_description do
    short I18n.t('docs.users.short_description')
    description I18n.t('docs.users.long_description')
  end

  api :POST, '/users', I18n.t('docs.users.actions.create')
  param :username, String, I18n.t('docs.users.params.username'), required: true
  param :password, String, I18n.t('docs.users.params.password'), required: true
  param :password_confirmation, String, I18n.t('docs.users.params.password_confirmation'), required: true
  def create
    user = User.new(user_params)
    return render json: user, status: :created if user.save

    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
