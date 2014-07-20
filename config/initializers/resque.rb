redis_url = ENV['REDISTOGO_URL'] || ENV['REDISCLOUD_URL']
Resque.redis = { url: redis_url } if redis_url
Resque.inline = Rails.env.test?
