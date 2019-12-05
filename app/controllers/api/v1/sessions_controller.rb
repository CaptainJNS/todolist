class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  resource_description do
    short I18n.t('docs.sessions.short_description')
    description I18n.t('docs.sessions.long_description', header: I18n.t(:auth))
  end

  api :POST, '/session', I18n.t('docs.sessions.actions.create')
  param :username, String, I18n.t('docs.sessions.params.username'), required: true
  param :password, String, I18n.t('docs.sessions.params.password'), required: true
  def create
    user = User.find_by_username(params[:username])
    return render json: { error: I18n.t('errors.invalid_login') }, status: :unauthorized unless user&.authenticate(params[:password])

    render json: {
      header: I18n.t('auth'),
      token: JsonWebToken.encode(user_id: user.id),
      exp: Constants::TOKEN_EXP_DATE.from_now.strftime(Constants::DATE_TIME_FORMAT),
      user: user
    }, status: :ok
  end

  api :DELETE, '/session', I18n.t('docs.sessions.actions.destroy')
  def destroy
    Rails.cache.redis.setex(request.headers[I18n.t('auth')], Constants::TOKEN_EXP_DATE, :expired)
  end
end
