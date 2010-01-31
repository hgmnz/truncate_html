require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlString do

  def html_string(original_string)
    TruncateHtml::HtmlString.new(original_string)
  end

  describe '#html_tokens' do
    before(:each) do
      @html = '<h1>Hi there</h1> <p>This          is sweet!</p>'
    end

    it 'returns each token in the string as an array element removing any consecutive whitespace from the string' do
      html_string(@html).html_tokens.should == ['<h1>', 'Hi', ' ', 'there', '</h1>', ' ', '<p>', 'This', ' ', 'is', ' ', 'sweet!', '</p>']
    end

  end

  describe '#html_tag?' do

    it 'returns false when the string parameter is not an html tag' do
      html_string('no tags').html_tag?.should be_false
    end

    it 'returns true when the string parameter is an html tag' do
      html_string('<img src="foo">').html_tag?.should be_true
      html_string('</img>').html_tag?.should be_true
    end

  end

  describe '#open_tag?' do

    it 'returns true if the tag is an open tag' do
      html_string('<a>').open_tag?.should be_true
    end

    context 'the tag is an open tag, and has whitespace and html properties' do
      it 'returns true if it has single quotes' do
        html_string(" <a href='http://awesomeful.net' >").open_tag?.should be_true
      end

      it 'returns true if it has double quotes' do
        html_string(' <a href="http://awesomeful.net">').open_tag?.should be_true
      end
    end

    it 'returns false if the tag is a close tag' do
      html_string('</a>').open_tag?.should be_false
    end

    it 'returns false if the string is not an html tag' do
      html_string('foo bar').open_tag?.should be_false
    end

    it 'returns false if it is a <script> tag' do
      html_string('<script>').open_tag?.should be_false
    end
  end

  describe '#matching_close_tag' do
    tag_pairs = { '<a>'             => '</a>',
                  ' <div>'          => '</div>',
                  '<h1>'            => '</h1>',
                  '<a href="foo">'  => '</a>' }

    tag_pairs.each do |open_tag, close_tag|
      it "closes a #{open_tag} and returns #{close_tag}" do
        html_string(open_tag).matching_close_tag.should == close_tag
      end
    end

  end

end
