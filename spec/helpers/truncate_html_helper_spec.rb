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

  context 'HtmlTruncator' do
    before(:each) do
      @html_truncator_mock = mock(TruncateHtml::HtmlTruncator)
    end

    it 'creates an instance of HtmlTruncator and calls truncate() on it' do
      @html_truncator_mock.stub!(:truncate).and_return(@original_html)
      TruncateHtml::HtmlTruncator.should_receive(:new).and_return(@html_truncator_mock)
      truncator.truncate_html(@original_html)
    end

    it 'calls truncate() on the HtmlTruncator object' do
      TruncateHtml::HtmlTruncator.stub!(:new).and_return(@html_truncator_mock)
      @html_truncator_mock.should_receive(:truncate).with({}).once.and_return(@original_html)
      truncator.truncate_html('foo')
    end
  end

  context 'HtmlCounter' do
    before(:each) do
      @html_counter_mock = mock(TruncateHtml::HtmlCounter)
    end

    it 'creates an instance of HtmlCounter and calls count() on it' do
      @html_counter_mock.stub!(:count).and_return(3)
      TruncateHtml::HtmlCounter.should_receive(:new).and_return(@html_counter_mock)
      truncator.count_html(@original_html)
    end

    it 'calls count() on the HtmlCounter object' do
      TruncateHtml::HtmlCounter.stub!(:new).and_return(@html_counter_mock)
      @html_counter_mock.should_receive(:count).once.and_return(3)
      truncator.count_html('foo')
    end
  end

  context 'the input html is nil' do
    it 'returns an empty string' do
      truncator.truncate_html(nil).should be_empty
      truncator.truncate_html(nil).should be_kind_of(String)
    end

    it 'returns 0' do
      truncator.count_html(nil).should be(0)
    end
  end

end
