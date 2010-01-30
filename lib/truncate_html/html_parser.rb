module TruncateHtml
  module HtmlParser
    extend self

    UNPAIRED_TAGS = %w(br hr img)

    def html_tokens(original_html)
      original_html.scan(/(?:<script.*>.*<\/script>)+|<\/?[^>]+>|[\w\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+|\s+/).map do
        |t| t.gsub(
          #remove newline characters
            /\n/,''
        ).gsub(
          #clean out extra consecutive whitespace
            /\s+/, ' '
        )
      end
    end

    def html_tag?(string)
      string =~ /<\/?[^>]+>/ ? true : false
    end

    def open_tag?(html_tag)
      html_tag =~ /<(?!(?:#{UNPAIRED_TAGS.join('|')}|script|\/))[^>]+>/i ? true : false
    end

    def remove_latest_open_tag(close_tag)
      (0...@open_tags.length).to_a.reverse.each do |i|
        if matching_close_tag(@open_tags[i]) == close_tag
          @open_tags.delete_at(i)
          break
        end
      end
    end

    def matching_close_tag(open_tag)
      open_tag.gsub(/<(\w+)\s?.*>/, '</\1>').strip
    end


  end
end
