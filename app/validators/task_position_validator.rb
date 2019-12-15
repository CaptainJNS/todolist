class TaskPositionValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    check_position(record, value) unless record.new_record?
  end

  private

  def check_position(record, value)
    record.errors.add(:base, I18n.t('errors.invalid_position')) if value <= 0 || value > max_position(record)
  end

  def max_position(record)
    record.project.tasks.count
  end
end
