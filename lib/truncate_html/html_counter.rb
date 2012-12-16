module TruncateHtml
  class HtmlCounter

    def initialize(original_html)
      @original_html  = original_html
    end

    def count
      @char_count = 0
      @open_tags = []

      @original_html.html_tokens.each { |token| process_token(token) }

      @char_count
    end

    private

      def process_token(token)
        if token.html_tag?
          if token.open_tag?
            @open_tags << token
          else
            remove_latest_open_tag(token)
          end
        else
          @char_count += token.length
        end
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
