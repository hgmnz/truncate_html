module TruncateHtmlHelper

  def truncate_html(html, options={})
    return '' if html.nil?
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlTruncator.new(html_string).truncate(options)
  end

end
