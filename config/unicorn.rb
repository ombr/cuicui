worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true
listen ENV['PORT'] || 3000

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM && sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM && doing nothing. Wait for master to send QUIT'
  end

  if defined? AnalyticsRuby &&  ENV['SEGMENT_IO'].present?
    Analytics = AnalyticsRuby
    Analytics.init(
      secret: ENV['SEGMENT_IO'],
      on_error: Proc { |status, msg| print msg }
    )
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
