class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :sign_in

  def sign_in
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + Constants::TOKEN_EXP_DATE
      render json: { token: token, exp: time.strftime(Constants::DATE_TIME_FORMAT),
                     user: @user }, status: :ok
    else
      render json: { error: I18n.t('errors.invalid_login') }, status: :unauthorized
    end
  end

  def sign_out
    Rails.cache.redis.setex(request.headers[I18n.t('auth')], Constants::TOKEN_EXP_DATE, :expired)
  end
end
