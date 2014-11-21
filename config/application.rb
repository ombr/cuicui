require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Cuicui
  # Application
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

    config.action_controller.asset_host =
      "//#{ENV['ASSET_DOMAIN']}" if ENV['ASSET_DOMAIN']

    config.middleware.insert_before 0,
                                    'Rack::Cors',
                                    logger: (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/cors',
                 headers: :any,
                 methods: [:post],
                 credentials: true,
                 max_age: 0

        resource '*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :options, :head],
                 max_age: 0
      end
    end
  end
end
