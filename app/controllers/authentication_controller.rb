class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :sign_in

  def sign_in
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     user: @user }, status: :ok
    else
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  def sign_out
    add_token_to_blacklist(request.headers['Authorization'])
  end

  private

  def add_token_to_blacklist(token)
    # TODO
  end
end
