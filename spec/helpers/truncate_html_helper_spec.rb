require File.join(File.dirname(__FILE__), '..', 'spec_helper')

include TruncateHtmlHelper

class Truncator
  include TruncateHtmlHelper
end

describe TruncateHtmlHelper do

  def truncator
    @truncator ||= Truncator.new
  end

  it 'is included in ActionView::Base' do
    ActionView::Base.included_modules.should include(TruncateHtmlHelper)
  end

  before(:each) do
    @original_html = '<p>foo</p>'
    @original_html.stub!(:html_safe).and_return(@original_html)
  end

  it 'creates an instance of HtmlTruncator and calls truncate on it' do
    truncator = double(truncate: @original_html)
    TruncateHtml::HtmlTruncator.should_receive(:new).and_return(truncator)
    truncator.truncate_html(@original_html)
  end

  it 'calls truncate on the HtmlTruncator object' do
    truncator = double(truncate: @original_html)
    TruncateHtml::HtmlTruncator.stub!(:new).and_return(truncator)
    truncator.should_receive(:truncate).and_return(@original_html)
    truncator.truncate_html('foo')
  end

  context 'the input html is nil' do
    it 'returns an empty string' do
      truncator.truncate_html(nil).should be_empty
      truncator.truncate_html(nil).should be_kind_of(String)
    end
  end

end
