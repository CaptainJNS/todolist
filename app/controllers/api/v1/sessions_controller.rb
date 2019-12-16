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
    result = CreateSession.call(username: params[:username], password: params[:password])
    render json: result.data, status: result.status
  end

  api :DELETE, '/session', I18n.t('docs.sessions.actions.destroy')
  def destroy
    Rails.cache.redis.setex(request.headers[I18n.t('auth')], Constants::TOKEN_EXP_DATE, :expired)
  end
end
