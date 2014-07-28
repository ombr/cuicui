require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Cuicui
  class Application < Rails::Application

    config.i18n.enforce_available_locales = true
    config.active_record.schema_format = :sql

    config.active_record.default_timezone = :utc

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.i18n.available_locales = [:en, :fr]
    config.i18n.default_locale = :en
    config.action_mailer.default_url_options = { host: "www.#{ENV['DOMAIN']}" }
  end
end
