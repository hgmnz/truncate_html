module TruncateHtml
  class HtmlTruncator

    def initialize(original_html)
      @original_html  = original_html
    end

    def truncate(options = {})
      return '' if @original_html.nil?
      length = options[:length] || 100
      omission = options[:omission] || '...'
      @chars_remaining = length - omission.length
      @open_tags, result = [], ['']

      @original_html.html_tokens.each do |str|
        if @chars_remaining > 0
          if str.html_tag?
            if str.open_tag?
              @open_tags << str
            else
              remove_latest_open_tag(str)
            end
          else
            @chars_remaining -= str.length
          end
          result << str
        else
          result[-1] = result[-1].rstrip + omission
          @open_tags.reverse_each do |open_tag|
            result << open_tag.matching_close_tag
          end
          break
        end
      end
      result.join('')
    end

    def remove_latest_open_tag(close_tag)
      (0...@open_tags.length).to_a.reverse.each do |index|
        if @open_tags[index].matching_close_tag == close_tag
          @open_tags.delete_at(index)
          break
        end
      end
    end

  end
end
