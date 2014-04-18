IntercomRails.config do |config|
  config.app_id = ENV['INTERCOM']

  config.api_secret = ENV['INTERCOM_SECRET']

  config.enabled_environments = %w(development production)

  config.user.custom_data = {
    pages: proc { Page.count },
    images: proc { Image.count }
  }
end
