require File.join(File.dirname(__FILE__), '..', 'spec_helper')

include TruncateHtmlHelper

describe TruncateHtmlHelper do

  describe '#truncate_html' do

    before(:each) do
      @html = '<ul><li><a href="foo">I\'m a link</a><li></ul>'
    end

    it 'should truncate, and close the <a>, <li> and <ul> tags' do
      truncate_html(@html, :length => 5).should == '<ul> <li> <a href="foo"> I\'m a...</a> </li> </ul>'
    end
  end

  describe '#html_tokens' do
    before(:each) do
      @html = <<-END_HTML
        <h1>Hi there</h1>
        <p>This is sweet!</p>
      END_HTML
    end

    it 'should return each token in the string as an array element' do
      html_tokens(@html).should == ['<h1>', 'Hi', 'there','</h1>','<p>','This','is','sweet!','</p>']
    end
  end

  describe '#html_tag?' do
    it 'should be false when the string parameter is not an html tag' do
      html_tag?('no tags').should be_false
    end

    it 'should be true when the string parameter is an html tag' do
      html_tag?('<img src="foo">').should be_true
    end
  end

  describe '#open_tag?' do
    it 'should be true if the tag is an open tag' do
      open_tag?('<a>').should be_true
    end

    it 'should be true if the tag is an open tag, and has whitespace and html properties with either single or double quotes' do
      open_tag?(' <a href="whatever">').should be_true
      open_tag?(" <a href='whatever' >").should be_true
    end

    it 'should be false if the tag is a close tag' do
      open_tag?('</a>').should be_false
    end

    it 'should be false if the string isnot an html tag' do
      open_tag?('random stuff').should be_false
    end
  end

  describe '#escape_special_chars' do
    ['^', '$', '.', '|', '?', '*', '+', '-'].each do |char|
      it "should backslash a #{char}" do
        escape_special_chars("some_text_with_a_#{char}_on_it").should == "some_text_with_a_\\" + char + "_on_it"
      end
    end
  end

  describe '#matching_close_tag' do
    it 'should close a tag given an open tag' do
      matching_close_tag('<a>').should == '</a>'
      matching_close_tag(' <div>').should == '</div>'
      matching_close_tag('<h1>').should == '</h1>'
      matching_close_tag('<a href="foo">').should == '</a>'
    end
  end

  describe '#remove_open_tag' do
    before(:each) do
      @open_tags = ['<a>', '<p>', '<div>', '<h1>', '<div>']
    end

    it 'should remove the latest matching tag' do
      remove_latest_open_tag(@open_tags, '</h1>').should == ['<a>', '<p>', '<div>', '<div>']
      remove_latest_open_tag(@open_tags, '</div>').should == ['<a>', '<p>', '<div>', '<h1>']
    end

    it 'should return the open_tags array if the close tag didn not match' do
      remove_latest_open_tag(@open_tags, '<strong>').should == @open_tags
    end
  end

  

end
