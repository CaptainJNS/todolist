class TaskDoneValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, _value)
    check_done(record)
  end

  private

  def check_done(record)
    record.errors.add(:base, I18n.t('errors.invalid_done')) unless record.done_before_type_cast.in?(%w[true false])
  end
end
