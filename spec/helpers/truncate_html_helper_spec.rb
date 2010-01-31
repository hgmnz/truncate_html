require File.join(File.dirname(__FILE__), '..', 'spec_helper')

include TruncateHtmlHelper

describe TruncateHtmlHelper do

  it 'is included in ActionView::Base' do
    ActionView::Base.included_modules.should include(TruncateHtmlHelper)
  end

  def do_truncate(html, opts={})
    truncate_html(html, opts)
  end

  before(:each) do
    @html_truncator_mock = mock(TruncateHtml::HtmlTruncator)
  end

  it 'creates an instance of HtmlTruncator and calls truncate() on it' do
    @html_truncator_mock.stub!(:truncate)
    TruncateHtml::HtmlTruncator.should_receive(:new).and_return(@html_truncator_mock)
    do_truncate('foo')
  end

  it 'calls truncate() on the HtmlTruncator object' do
    TruncateHtml::HtmlTruncator.stub!(:new).and_return(@html_truncator_mock)
    @html_truncator_mock.should_receive(:truncate).with({}).once
    do_truncate('foo')
  end

  context 'the input html is nil' do
    it 'returns an empty string' do
      do_truncate(nil).should be_empty
      do_truncate(nil).should be_kind_of(String)
    end
  end

end
