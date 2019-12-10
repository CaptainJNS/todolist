class TaskPositionValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    return check_position(record, value) unless record.new_record?

    record.position = default_value(record)
  end

  private

  def check_position(record, value)
    record.errors.add(:base, I18n.t('errors.invalid_position')) if value.zero? || value > max_position(record)
  end

  def max_position(record)
    record.project.tasks.count
  end

  def default_value(record)
    Task.where(project: record.project).count.next
  end
end
