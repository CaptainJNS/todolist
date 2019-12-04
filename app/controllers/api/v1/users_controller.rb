class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

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
