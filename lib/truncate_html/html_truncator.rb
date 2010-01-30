module TruncateHtml
  class HtmlTruncator
    include HtmlParser


    def initialize(original_html)
      @original_html  = original_html
    end

    def truncate(options = {})
      return '' if @original_html.nil?
      options[:length] ||= 100
      options[:omission] ||= '...'
      @chars_remaining = options[:length] - options[:omission].length
      @open_tags, result = [], ['']

      html_tokens(@original_html).each do |str|
        if @chars_remaining > 0
          if html_tag?(str)
            if open_tag?(str)
              @open_tags << str
            else
              remove_latest_open_tag(str)
            end
          else
            @chars_remaining -= str.length
          end
          result << str
        else
          result[-1] = result[-1].rstrip + options[:omission]
          @open_tags.reverse_each do |open_tag|
            result << matching_close_tag(open_tag)
          end
          break
        end
      end
      result.join('')
    end
  end
end
