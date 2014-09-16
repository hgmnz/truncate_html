module TruncateHtml
  class HtmlTruncator

    def initialize(original_html, options = {})
      @original_html   = original_html
      length           = options[:length]       || TruncateHtml.configuration.length
      @omission        = options[:omission]     || TruncateHtml.configuration.omission
      @word_boundary   = (options.has_key?(:word_boundary) ? options[:word_boundary] : TruncateHtml.configuration.word_boundary)
      @break_token     = options[:break_token] || TruncateHtml.configuration.break_token || nil
      @chars_remaining = length - @omission.length
      @open_tags, @closing_tags, @truncated_html = [], [], ['']
    end

    def truncate
      return @omission if @chars_remaining < 0
      @original_html.html_tokens.each do |token|
        if @chars_remaining <= 0 || truncate_token?(token)
          close_open_tags
          break
        else
          process_token(token)
        end
      end

      build_output
    end

    private

    def word_boundary
      if @word_boundary == true
        TruncateHtml.configuration.word_boundary
      else
        @word_boundary
      end
    end

    def build_output
      out = @truncated_html.join
      if word_boundary
        term_regexp = Regexp.new("^.*#{word_boundary.source}")
        match = out.match(term_regexp)
        if match && match[0] != out
          out = match[0] + @closing_tags.join
        end
      end

      out
    end

    def process_token(token)
      append_to_result(token)
      if token.html_tag?
        if token.open_tag?
          @open_tags << token
        else
          remove_latest_open_tag(token)
        end
      elsif !token.html_comment?
        @chars_remaining -= (@word_boundary ? token.length : token[0, @chars_remaining].length)
        if @chars_remaining <= 0
          @truncated_html[-1] = @truncated_html[-1].rstrip + @omission
        end
      end
    end

    def append_to_result(token)
      if token.html_tag? || token.html_comment?
        @truncated_html << token
      elsif @word_boundary
        @truncated_html << token if (@chars_remaining - token.length) >= 0
      else
        @truncated_html << token[0, @chars_remaining]
      end
    end

    def close_open_tags
      @open_tags.reverse_each do |open_tag|
        @closing_tags << open_tag.matching_close_tag
        @truncated_html << open_tag.matching_close_tag
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

    def truncate_token?(token)
      @break_token and token == @break_token
    end
  end
end
