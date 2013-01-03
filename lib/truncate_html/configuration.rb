module TruncateHtml
  class Configuration
    attr_accessor :length, :omission, :word_boundary

    attr_writer :break_token
    def break_token
      @break_token || '<!-- truncate -->'
    end
    
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end
end
