# https://devcenter.heroku.com/articles/rails-unicorn

worker_processes((ENV['WEB_CONCURRENCY'] || 3).to_i)
timeout((ENV['WEB_TIMEOUT'] || 5).to_i)
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    Process.kill 'QUIT', Process.pid
  end

  ActiveRecord::Base.connection.disconnect!  if defined? ActiveRecord::Base
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
  end

  if defined? ActiveRecord::Base
    config = ActiveRecord::Base.configurations[Rails.env] ||
             Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = (ENV['DB_REAPING_FREQUENCY'] || 10).to_i
    config['pool'] = (ENV['DB_POOL'] || 2).to_i
    ActiveRecord::Base.establish_connection(config)
  end
end
