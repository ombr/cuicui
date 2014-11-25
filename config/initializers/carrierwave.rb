if ENV['AWS_KEY']
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET']
    }
    config.fog_directory  = ENV['AWS_BUCKET']
    config.fog_attributes = {
      'Cache-Control' => 'max-age=315576000',
      Expires: 1.year.from_now.httpdate
    }
  end
end
