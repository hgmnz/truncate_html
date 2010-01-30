require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlTruncator do

  def truncator(html = nil)
    @truncator ||= TruncateHtml::HtmlTruncator.new(html)
  end


  describe 'nil string' do

    it 'returns an empty string' do
      truncator(nil).truncate.should be_empty
      truncator(nil).truncate.should be_kind_of(String)
    end
  end

end
