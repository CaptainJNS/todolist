class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_reader :current_user

  def authorize_request
    header = request.headers[I18n.t('auth')]
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
