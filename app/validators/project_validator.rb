class ProjectValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    check_uniqueness(record, attribute, value)
  end

  private

  def check_uniqueness(record, attribute, value)
    record.errors.add(:base, I18n.t('errors.project_exist')) if record.user&.projects&.find_by(attribute => value)
  end
end
