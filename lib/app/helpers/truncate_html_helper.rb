module TruncateHtmlHelper

  def truncate_html(html, options={})
    TruncateHtml::HtmlTruncator.new(html).truncate(options)
  end

end
