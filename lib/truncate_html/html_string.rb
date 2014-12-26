# encoding: utf-8
module TruncateHtml
  class HtmlString < String

    UNPAIRED_TAGS = %w(br hr img).freeze
    REGEX = %r{
      (?:<script.*>.*<\/script>)+ # Match script tags. They aren't counted in length.
      |
      <\/?[^>]+> # Match html tags
      |
      [[[:alpha:]]\p{Sc}[\p{Sm}&&[^<]][0-9]\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'²³§",\.\/?]+ # Match tag body
      |
      \s+ # Match consecutive spaces. They are later truncated to a single space.
      |
      [[:punct:]] # Don't gobble up Chinese punctuation characters
    }x.freeze

    def initialize(original_html)
      super(original_html)
    end

    def html_tokens
      scan(REGEX).map do |token|
        HtmlString.new(
          token.gsub(
            /\n/,' ' #replace newline characters with a whitespace
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

  end
end
