require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlTruncator do

  def truncator(html = nil)
    @truncator ||= TruncateHtml::HtmlTruncator.new(html)
  end

  describe '#html_tokens' do
    before(:each) do
      @html = '<h1>Hi there</h1> <p>This is sweet!</p>'
    end

    it 'returns each token in the string as an array element' do
      truncator(@html).html_tokens.should == ['<h1>', 'Hi', ' ', 'there', '</h1>', ' ', '<p>', 'This', ' ', 'is', ' ', 'sweet!', '</p>']
    end
  end

  describe '#html_tag?' do

    it 'returns false when the string parameter is not an html tag' do
      truncator.html_tag?('no tags').should be_false
    end

    it 'returns true when the string parameter is an html tag' do
      truncator.html_tag?('<img src="foo">').should be_true
      truncator.html_tag?('</img>').should be_true
    end

  end

  describe '#open_tag?' do

    it 'returns true if the tag is an open tag' do
      truncator.open_tag?('<a>').should be_true
    end

    it 'returns true if the tag is an open tag, and has whitespace and html properties with either single or double quotes' do
      truncator.open_tag?(' <a href="http://awesomeful.net">').should be_true
      truncator.open_tag?(" <a href='http://awesomeful.net' >").should be_true
    end

    it 'returns false if the tag is a close tag' do
      truncator.open_tag?('</a>').should be_false
    end

    it 'returns false if the string is not an html tag' do
      truncator.open_tag?('foo bar').should be_false
    end
  end

  describe '#matching_close_tag' do

    it 'closes a tag given an open tag' do
      truncator.matching_close_tag('<a>').should == '</a>'
      truncator.matching_close_tag(' <div>').should == '</div>'
      truncator.matching_close_tag('<h1>').should == '</h1>'
      truncator.matching_close_tag('<a href="foo">').should == '</a>'
    end
  end

  describe 'nil string' do

    it 'returns an empty string' do
      truncator(nil).truncate.should be_empty
      truncator(nil).truncate.should be_kind_of String
    end
  end

end
