# LocalFile
class LocalFile
  attr_reader :uri

  def self.process(url)
    file = new(URI.parse(url)).file
    yield file
  ensure
    file.close
    file.unlink
  end

  def initialize(uri)
    @uri = uri
  end

  def file
    @file ||= Tempfile.new(tmp_filename,
                           tmp_folder,
                           encoding: encoding).tap do |f|
      io.rewind
      f.write(io.read)
      f.close
    end
  end

  def io
    @io ||= uri.open
  end

  def encoding
    io.rewind
    io.read.encoding
  end

  def tmp_filename
    [
      Pathname.new(uri.path).basename,
      Pathname.new(uri.path).extname
    ]
  end

  def tmp_folder
    Rails.root.join('tmp')
  end
end
