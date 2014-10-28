# Font
class Font
  def self.webfonts_url
    base = 'https://www.googleapis.com/webfonts/v1/webfonts?key='
    "#{base}#{ENV['GOOGLE_FONT_KEY']}"
  end

  def self.all
    Rails.cache.fetch('fonts', expires_in: 24.hours) do
      JSON.parse(HTTParty.get(webfonts_url).body)['items']
    end
  end

  def self.families
    all.map { |e| e['family'] }
  end
end
