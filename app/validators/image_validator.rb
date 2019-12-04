class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    check_type(record, attribute, value)
    check_size(record, attribute, value)
  end

  private

  def check_type(record, attribute, value)
    record.errors.add(attribute, I18n.t('errors.invalid_image_type')) unless value.content_type.in?(Constants::PERMITTED_IMAGE_TYPES)
  end

  def check_size(record, attribute, value)
    record.errors.add(attribute, I18n.t('errors.invalid_image_size')) if value.blob.byte_size > Constants::IMAGE_MAX_SIZE
  end
end
