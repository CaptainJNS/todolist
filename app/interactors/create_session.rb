class CreateSession
  include Interactor

  def call
    user = User.find_by_username(context.username)
    unless user&.authenticate(context.password)
      context.data = { error: I18n.t('errors.invalid_login') }
      context.status = :unauthorized
      return context.fail!
    end

    context.data = {
      header: I18n.t('auth'),
      token: JsonWebToken.encode(user_id: user.id),
      exp: Constants::TOKEN_EXP_DATE.from_now.strftime(Constants::DATE_TIME_FORMAT),
      user: user
    }
    context.status = :ok
  end
end
