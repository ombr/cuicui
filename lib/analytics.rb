module Analytics
  def analytics_track(event, properties = {})
    return unless ENV['SEGMENT_IO']
    analytics_identify_user
    properties.merge!(noninteraction: 0)
    analytics.track(
      user_id: (current_user.id if user_signed_in?),
      event: event,
      properties: properties,
      context: analytics_context
    )
  end

  def analytics
    @analytics ||= Segment::Analytics.new(write_key: ENV['SEGMENT_IO'])
    @analytics
  end

  def analytics_identify_user
    return unless ENV['SEGMENT_IO']
    options = {
      context: {
        userAgent: request.env['HTTP_USER_AGENT'],
        locale: I18n.locale,
        ip: request.remote_ip
      }
    }
    options.merge!(analytics_user_options) if user_signed_in?
    analytics.identify(options)
  end

  def analytics_user_options
    {
      user_id: current_user.id,
      traits: {
        email: current_user.email
      }
    }
  end

  def analytics_context
    {
      'Google Analytics' => {
        clientId: google_analytics_client_id,
        userAgent: request.env['HTTP_USER_AGENT'],
        locale: I18n.locale,
        ip: request.remote_ip
      }
    }
  end

  def google_analytics_client_id
    google_analytics_cookie.gsub(/^GA\d\.\d\./, '')
  end

  def google_analytics_cookie
    cookies['_ga'] || ''
  end
end
