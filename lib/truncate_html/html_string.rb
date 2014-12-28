# encoding: utf-8
module TruncateHtml
  class HtmlString < String

    UNPAIRED_TAGS = %w(br hr img).freeze
    TAG_BODY_CHARACTERS =
      '[[:alpha:]]' + # Match unicode alphabetical characters
      '\p{Sc}' + # Match unicode currency characters
      '\p{So}' + # Match unicode other symbols
      '[\p{Sm}&&[^<]]' + # Match unicode math symbols except ascii <. < opens html tags.
      '[\p{Zs}&&[^\s]]' + # Match unicode space characters except \s+
      '[0-9]' + # Match digits
      %q(\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'²³§",\.\/?) + # Match some special characters
      '[[:punct:]]' # Don't gobble up chinese punctuation characters
    REGEX = %r{
      (?:<script.*>.*<\/script>)+ # Match script tags. They aren't counted in length.
      |
      <\/?[^>]+> # Match html tags
      |
      \s+ # Match consecutive spaces. They are later truncated to a single space.
      |
      [#{TAG_BODY_CHARACTERS}]+ # Match tag body
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
