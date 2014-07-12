# FileUploader
class FileUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  def fog_public
    false
  end

  def fog_authenticated_url_expiration
    5.minutes
  end

  def max_file_size
    10.megabytes
  end

  def params
    {
      utf8: '✓',
      key: key,
      AWSAccessKeyId: aws_access_key_id,
      acl: acl,
      policy: policy,
      signature: signature,
      success_action_status: '201'
    }
  end
end
