ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/email/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # need to remove the next 3 lines :
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.raise_errors_for_deprecations!
  config.infer_spec_type_from_file_location!
  config.render_views = true
  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include Devise::TestHelpers, type: :controller

  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.reload

  Fog.mock!
  def fog_directory
    ENV['AWS_BUCKET']
  end
  connection = ::Fog::Storage.new(
    aws_access_key_id: ENV['AWS_KEY'],
    aws_secret_access_key: ENV['AWS_SECRET'],
    provider: 'AWS'
  )
  connection.directories.create(key: fog_directory)

  FakeWeb.allow_net_connect = false

  config.before :each, type: :controller do
    request.env['HTTP_ACCEPT_LANGUAGE'] = ENV['TEST_LANG']
    request.env['HTTP_ACCEPT_LANGUAGE'] ||= %w(fr en).sample
  end
end

Capybara.javascript_driver = :webkit
