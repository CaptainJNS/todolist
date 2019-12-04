class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

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

  def destroy
    Rails.cache.redis.setex(request.headers[I18n.t('auth')], Constants::TOKEN_EXP_DATE, :expired)
  end
end
