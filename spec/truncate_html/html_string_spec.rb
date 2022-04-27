#encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlString do

  def html_string(original_string)
    TruncateHtml::HtmlString.new(original_string)
  end

  describe '#html_tokens' do
    it 'returns each token in the string as an array element removing any consecutive whitespace from the string' do
      html = '<h1>Hi there</h1> <p>This          is sweet!</p> <p> squaremeter m² </p>'
      expect(html_string(html).html_tokens).to eq(['<h1>', 'Hi', ' ', 'there', '</h1>', ' ', '<p>', 'This', ' ', 'is', ' ', 'sweet!', '</p>',
        ' ', '<p>', ' ', 'squaremeter', ' ', 'm²', ' ', '</p>'])
    end
  end

  describe '#html_tag?' do
    it 'returns false when the string parameter is not an html tag' do
      expect(html_string('no tags')).not_to be_html_tag
    end

    it 'returns true when the string parameter is an html tag' do
      expect(html_string('<img src="foo">')).to be_html_tag
      expect(html_string('</img>')).to be_html_tag
    end

    it 'is false for html comments' do
      expect(html_string('<!-- hi -->')).not_to be_html_tag
    end
  end

  describe '#open_tag?' do
    it 'returns true if the tag is an open tag' do
      expect(html_string('<a>')).to be_open_tag
    end

    context 'the tag is an open tag, and has whitespace and html properties' do
      it 'returns true if it has single quotes' do
        expect(html_string(" <a href='http://awesomeful.net' >")).to be_open_tag
      end

      it 'returns true if it has double quotes' do
        expect(html_string(' <a href="http://awesomeful.net">')).to be_open_tag
      end
    end

    it 'returns false if the tag is a close tag' do
      expect(html_string('</a>')).not_to be_open_tag
    end

    it 'returns false if the string is not an html tag' do
      expect(html_string('foo bar')).not_to be_open_tag
    end

    it 'returns false if it is a <script> tag' do
      expect(html_string('<script>')).not_to be_open_tag
    end
  end

  describe '#matching_close_tag' do
    tag_pairs = { '<a>'            => '</a>',
                  ' <div>'         => '</div>',
                  '<h1>'           => '</h1>',
                  '<a href="foo">' => '</a>' }

    tag_pairs.each do |open_tag, close_tag|
      it "closes a #{open_tag} and returns #{close_tag}" do
        expect(html_string(open_tag).matching_close_tag).to eq(close_tag)
      end
    end
  end

  describe '#html_comment?' do
    it 'is true for HTML comments' do
      expect(html_string('<!-- hi -->')).to be_html_comment
      expect(html_string('<a>')).not_to be_html_comment
      expect(html_string('</a>')).not_to be_html_comment
      expect(html_string('foo')).not_to be_html_comment
    end
  end
end
