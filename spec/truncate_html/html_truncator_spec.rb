# Encoding: UTF-8
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlTruncator do

  def truncate(html, opts = {})
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlTruncator.new(html_string).truncate(opts)
  end

  describe '#truncate' do

    context 'when the word_boundary option is set to false' do
      it 'truncates to the exact length specified' do
        truncate('<div>123456789</div>', :length => 5, :omission => '', :word_boundary => false).should == '<div>12345</div>'
      end
    end

    it "includes the omission text's length in the returned truncated html" do
      truncate('a b c', :length => 4, :omission => '...').should == 'a...'
    end

    it "never returns a string longer than :length" do
      truncate("test this shit", :length => 10).should == 'test...'
    end

    it 'supports omissions longer than the maximum length' do
      lambda { truncate('', :length => 1, :omission => '...') }.should_not raise_error
    end

    it 'returns the omission when the specified length is smaller than the omission' do
      truncate('a b c', :length => 2, :omission => '...').should == '...'
    end

    context 'the input html contains a script tag' do
      before(:each) do
        @input_html = "<p>I have a script <script type=text/javascript>document.write('lum dee dum');</script> and more text</p>"
        @expected_out = "<p>I have a script <script type=text/javascript>document.write('lum dee dum');</script> and...</p>"
      end
      it 'treats the script tag as lengthless string' do
        truncate(@input_html, :length => 23).should == @expected_out
      end
    end

    context 'truncating in the middle of a link' do
      before(:each) do
        @html = '<div><ul><li>Look at <a href="foo">this</a> link </li></ul></div>'
      end

      it 'truncates, and closes the <a>, and closes any remaining open tags' do
        truncate(@html, :length => 15).should == '<div><ul><li>Look at <a href="foo">this...</a></li></ul></div>'
      end
    end

    %w(! @ # $ % ^ & * \( \) - _ + = [ ] { } \ | , . / ?).each do |char|
      context "when the html has a #{char} character after a closing tag" do
        before(:each) do
          @html = "<p>Look at <strong>this</strong>#{char} More words here</p>"
        end
        it 'places the punctuation after the tag without any whitespace' do
          truncate(@html, :length => 19).should == "<p>Look at <strong>this</strong>#{char}...</p>"
        end
      end
    end

    context 'when the html has a non punctuation character after a closing tag' do
      before(:each) do
        @html = '<p>Look at <a href="awesomeful.net">this</a> link for randomness</p>'
      end
      it 'leaves a whitespace between the closing tag and the following word character' do
        truncate(@html, :length => 21).should == '<p>Look at <a href="awesomeful.net">this</a> link...</p>'
      end
    end

    context 'when the characters are multibyte' do
      before(:each) do
        @html = '<p>Look at our multibyte characters ā ž <a href="awesomeful.net">this</a> link for randomness ā ž</p>'
      end

      it 'leaves the multibyte characters after truncation' do
        truncate(@html, :length => @html.length).should == '<p>Look at our multibyte characters ā ž <a href="awesomeful.net">this</a> link for randomness ā ž</p>'
      end
    end

    #unusual, but just covering my ass
    context 'when the HTML tags are multiline' do
      before(:each) do
        @html = <<-END_HTML
          <div id="foo"
                class="bar">
          This is ugly html.
          </div>
        END_HTML
      end

      it 'recognizes the multiline html properly' do
        truncate(@html, :length => 12).should == ' <div id="foo" class="bar"> This is...</div>'
      end
    end

    %w(br hr img).each do |unpaired_tag|
      context "when the html contains a #{unpaired_tag} tag" do

        context "and the #{unpaired_tag} does not have the closing slash" do
          before(:each) do
            @html = "<div>Some before. <#{unpaired_tag}>and some after</div>"
            @html_caps = "<div>Some before. <#{unpaired_tag.capitalize}>and some after</div>"
          end
          it "does not close the #{unpaired_tag} tag" do
            truncate(@html, :length => 19).should == "<div>Some before. <#{unpaired_tag}>and...</div>"
            truncate(@html_caps, :length => 19).should == "<div>Some before. <#{unpaired_tag.capitalize}>and...</div>"
          end
        end

        context "and the #{unpaired_tag} does have the closing slash" do
          before(:each) do
            @html = "<div>Some before. <#{unpaired_tag} />and some after</div>"
            @html_caps = "<div>Some before. <#{unpaired_tag.capitalize} />and some after</div>"
          end
          it "does not close the #{unpaired_tag} tag" do
            truncate(@html, :length => 19).should == "<div>Some before. <#{unpaired_tag} />and...</div>"
            truncate(@html_caps, :length => 19).should == "<div>Some before. <#{unpaired_tag.capitalize} />and...</div>"
          end
        end

      end
    end
  end

end
