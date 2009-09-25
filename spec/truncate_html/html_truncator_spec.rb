require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlTruncator do

  describe '#html_tokens' do
    before(:each) do
      @html = '<h1>Hi there</h1> <p>This is sweet!</p>'
      @truncator = TruncateHtml::HtmlTruncator.new @html
    end

    it 'should return each token in the string as an array element' do
      @truncator.send(:html_tokens).should == ['<h1>', 'Hi', ' ', 'there', '</h1>', ' ', '<p>', 'This', ' ', 'is', ' ', 'sweet!', '</p>']
    end
  end

  describe '#html_tag?' do

    before(:each) do
      @truncator = TruncateHtml::HtmlTruncator.new 'foo'
    end

    it 'should be false when the string parameter is not an html tag' do
      @truncator.send(:html_tag?, 'no tags').should be_false
    end

    it 'should be true when the string parameter is an html tag' do
      @truncator.send(:html_tag?, '<img src="foo">').should be_true
      @truncator.send(:html_tag?, '</img>').should be_true
    end

  end

  describe '#open_tag?' do

    before(:each) do
      @truncator = TruncateHtml::HtmlTruncator.new 'foo'
    end

    it 'should be true if the tag is an open tag' do
      @truncator.send(:open_tag?, '<a>').should be_true
    end

    it 'should be true if the tag is an open tag, and has whitespace and html properties with either single or double quotes' do
      @truncator.send(:open_tag?, ' <a href="http://awesomeful.net">').should be_true
      @truncator.send(:open_tag?, " <a href='http://awesomeful.net' >").should be_true
    end

    it 'should be false if the tag is a close tag' do
      @truncator.send(:open_tag?, '</a>').should be_false
    end

    it 'should be false if the string is not an html tag' do
      @truncator.send(:open_tag?, 'foo bar').should be_false
    end
  end

  describe '#matching_close_tag' do

    before(:each) do
      @truncator = TruncateHtml::HtmlTruncator.new 'foo'
    end

    it 'should close a tag given an open tag' do
      @truncator.send(:matching_close_tag, '<a>').should == '</a>'
      @truncator.send(:matching_close_tag, ' <div>').should == '</div>'
      @truncator.send(:matching_close_tag, '<h1>').should == '</h1>'
      @truncator.send(:matching_close_tag, '<a href="foo">').should == '</a>'
    end
  end
  
  describe 'nil string' do
    
    before(:each) do
      @truncator = TruncateHtml::HtmlTruncator.new nil
    end
    
    it 'should return an empty string' do
      @truncator.truncate.should == ''
    end
  end

end
