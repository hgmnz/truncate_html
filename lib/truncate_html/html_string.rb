module TruncateHtml
  class HtmlString < String

    UNPAIRED_TAGS = %w(br hr img)

    def initialize(original_html)
      super(original_html)
    end

    def html_tokens
      scan(/(?:<script.*>.*<\/script>)+|<\/?[^>]+>|[\w\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+|\s+/).map do
        |token| token.gsub(
          #remove newline characters
            /\n/,''
        ).gsub(
          #clean out extra consecutive whitespace
            /\s+/, ' '
        )
      end.map { |token| HtmlString.new(token) }
    end

    def html_tag?
      self =~ /<\/?[^>]+>/ ? true : false
    end

    def open_tag?
      self =~ /<(?!(?:#{UNPAIRED_TAGS.join('|')}|script|\/))[^>]+>/i ? true : false
    end

    def matching_close_tag
      gsub(/<(\w+)\s?.*>/, '</\1>').strip
    end

  end
end
