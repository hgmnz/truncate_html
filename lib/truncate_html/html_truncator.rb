module TruncateHtml
  class HtmlTruncator

    UNPAIRED_TAGS = %w(br hr img)

    def initialize(original_html)
      @original_html = original_html
    end

    def truncate(options = {})
      return '' if @original_html.nil?
      options[:length] ||= 100
      options[:omission] ||= '...'
      @chars_remaining = options[:length]
      @open_tags, result = [], []

      html_tokens.each do |str|
        if @chars_remaining > 0
          if html_tag?(str)
            if open_tag?(str)
              @open_tags << str 
            else
              open_tags = remove_latest_open_tag(str)
            end
          else
            @chars_remaining -= str.length
          end
          result << str
        else
          result[-1] += options[:omission] unless options[:omission].nil?
          @open_tags.reverse_each do |open_tag|
            result << matching_close_tag(open_tag)
          end
          break
        end
      end
      result.join('')
    end

    def html_tokens
      @original_html.scan(/<\/?[^>]+>|[\w\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+|\s+/).map do
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
      html_tag =~ /<(?!(?:#{UNPAIRED_TAGS.join('|')}|\/))[^>]+>/i ? true : false
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
