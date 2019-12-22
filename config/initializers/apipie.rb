I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
Apipie.configure do |config|
  config.app_name = Rails.application.class.parent_name
  config.api_base_url = '/api/v1'
  config.doc_base_url = '/documentation'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate = false
  config.validate_value = false
  config.validate_presence = false
  config.app_info = I18n.t('docs.default.app_info')
  config.copyright = I18n.t('docs.default.copyright')
end
