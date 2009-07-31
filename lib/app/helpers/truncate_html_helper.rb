module TruncateHtmlHelper

  def truncate_html(html, options={})
    options[:length] ||= 100
    options[:omission] ||= '...'
    chars_remaining = options[:length]
    open_tags, result = [], []

    html_tokens(html).each do |str|
      if chars_remaining > 0
        if html_tag?(str)
          if open_tag?(str)
            open_tags << str 
          else
            open_tags = remove_latest_open_tag(open_tags, str)
          end
        else
          chars_remaining -= (str.length + 1)
        end
        result << str
      else
        result[-1] += options[:omission] unless options[:omission].nil?
        open_tags.reverse.each do |open_tag|
          result << matching_close_tag(open_tag)
        end
        break
      end
    end
    construct_html_from_truncated_tokens(result)
  end

  private

  def html_tokens(html)
    html.scan /<\/?[^>]*>|[\w`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+/
  end

  def html_tag?(string)
    if string =~ /<\/?[^>]*>/ then true else false end
  end

  def open_tag?(html_tag)
    if html_tag =~ /<[\w\s='"]+>/ then true else false end
  end

  def matching_close_tag(open_tag)
    open_tag.gsub(/<(\w+)\s?.*>/, '</\1>').strip
  end

  def remove_latest_open_tag(open_tags, close_tag)
    (0...open_tags.length).to_a.reverse.each do |i|
      if matching_close_tag(open_tags[i]) == close_tag
        return open_tags[0...i] + open_tags[(i+1)...open_tags.length]
      end
    end
    return open_tags
  end

  def escape_special_chars(string)
    string.gsub(/([\^\$\.\|\?\*\+\-])/, '\\\\\1')
  end

  def construct_html_from_truncated_tokens(tokens)
    result=tokens.join(' ')
    result.gsub(
      #remove whitespace between word and closing html tag
      /([\w`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+?)\s+(<\/[^>]*>)/, '\1\2'
    ).gsub(
      #remove whitespace between closing tag and punctuation
      /(<\/[^>]*>)\s+([`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+?)/, '\1\2'
    ).gsub(
      #remove whitespace between open tag and word chars.
      /(<[^>]*>)\s+([`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'",\.\/?]+?)/, '\1\2'
    )
  end


end
