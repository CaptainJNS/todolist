class TaskDeadlineValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    check_deadline(record, value)
  end

  private

  def check_deadline(record, value)
    return record.errors.add(:base, I18n.t('errors.invalid_deadline')) if value.nil?

    record.errors.add(:base, I18n.t('errors.past_deadline')) if parse_deadline(value).past?
  end

  def parse_deadline(value)
    DateTime.parse(value.to_s)
  end
end
