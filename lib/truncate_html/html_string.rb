# encoding: utf-8
module TruncateHtml
  class HtmlString < String

    UNPAIRED_TAGS = %w(br hr img).freeze

    def initialize(original_html)
      super(original_html)
    end

    def html_tokens
      scan(regex).map do |token|
        HtmlString.new(
          token.gsub(
            /\n/,'' #remove newline characters
          ).gsub(
            /\s+/, ' ' #clean out extra consecutive whitespace
          )
        )
      end
    end

    def html_tag?
      /<\/?[^>]+>/ === self && !html_comment?
    end

    def open_tag?
      /<(?!(?:#{UNPAIRED_TAGS.join('|')}|script|\/))[^>]+>/i === self
    end

    def html_comment?
      /<\s?!--.*-->/ === self
    end

    def matching_close_tag
      gsub(/<(\w+)\s?.*>/, '</\1>').strip
    end

    private
    def regex
      /(?:<script.*>.*<\/script>)+|<\/?[^>]+>|[[[:alpha:]]\w\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+|\s+|[[:punct:]]/
    end

  end
end
