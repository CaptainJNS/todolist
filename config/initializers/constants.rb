# frozen_string_literal: true

module Constants
  DATE_TIME_FORMAT = '%m-%d-%Y %H:%M'
  TOKEN_EXP_DATE = 24.hours
  IMAGE_MAX_SIZE = 10.megabytes
  PERMITTED_IMAGE_TYPES = %w[image/jpeg image/jpg image/png].freeze
  PASSWORD_MIN_LENGTH = 8
  USERNAME_MIN_LENGTH = 3
  USERNAME_MAX_LENGTH = 50
  AMAZON_REGION = 'eu-west-2'
  AMAZON_BUCKET = 'todo-captainjns'
end
