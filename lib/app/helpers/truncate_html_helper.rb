module TruncateHtmlHelper

  def truncate_html(html, options={})
    TruncateHtml::HtmlTruncator.new(TruncateHtml::HtmlString.new(html)).truncate(options)
  end

end
