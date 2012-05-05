module TruncateHtmlHelper

  def truncate_html(html, options={})
    return '' if html.nil?
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlTruncator.new(html_string).truncate(options).html_safe
  end

  def count_html(html)
    return 0 if html.nil?
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlCounter.new(html_string).count
  end

end
