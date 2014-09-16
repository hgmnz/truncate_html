# Encoding: UTF-8
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlTruncator do

  def truncate(html, opts = {})
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlTruncator.new(html_string, opts).truncate
  end

  context 'when the word_boundary option is set to false' do
    it 'truncates to the exact length specified' do
      truncate('<div>123456789</div>', :length => 5, :omission => '', :word_boundary => false).should == '<div>12345</div>'
    end

    it 'retains the tags within the text' do
      html = 'some text <span class="caps">CAPS</span> some text'
      truncate(html, :length => 25, :word_boundary => false).should == 'some text <span class="caps">CAPS</span> some te...'
    end

    context 'and a custom omission value is passed' do
      it 'retains the omission text' do
        truncate("testtest", :length => 10, :omission => '..', :word_boundary => false).should == 'testtest..'
      end

      it 'handles multibyte characters' do
        truncate("prüfenprüfen", :length => 8, :omission => '..', :word_boundary => false). should == 'prüfen..'
      end
    end
  end

  context 'when the word_boundary option is set to true' do
    it 'truncates using the default word_boundary option' do
      truncate('hello there. or maybe not?', :length => 16, :omission => '', :word_boundary => true).should == 'hello there. or'
    end
  end

  context 'when the word_boundary option is a custom value (for splitting on sentences)' do
    it 'truncates to the end of the nearest sentence' do
      truncate('hello there. or maybe not?', :length => 16, :omission => '', :word_boundary => /\S[\.\?\!]/).should == 'hello there.'
    end

    it 'is respectful of closing tags' do
      truncate('<p>hmmm this <em>should</em> be okay. I think...</p>', :length => 28, :omission => '', :word_boundary => /\S[\.\?\!]/).should == "<p>hmmm this <em>should</em> be okay.</p>"
    end
  end

  it "includes the omission text's length in the returned truncated html" do
    truncate('a b c', :length => 4, :omission => '...').should == 'a...'
  end

  it "includes omission even on the edge (issue #18)" do
    opts = { :word_boundary => false, :length => 12 }
    truncate('One two three', opts).should == 'One two t...'
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

  it 'treats script tags as strings with no length' do
    input_html   = "<p>I have a script <script type = text/javascript>document.write('lum dee dum');</script> and more text</p>"
    expected_out = "<p>I have a script <script type = text/javascript>document.write('lum dee dum');</script> and...</p>"
    truncate(input_html, :length => 23).should == expected_out
  end

  it 'in the middle of a link, truncates and closes the <a>, and closes any remaining open tags' do
    html     = '<div><ul><li>Look at <a href = "foo">this</a> link </li></ul></div>'
    expected = '<div><ul><li>Look at <a href = "foo">this...</a></li></ul></div>'
    truncate(html, :length => 15).should == expected
  end

  %w(! @ # $ % ^ & * \( \) - _ + = [ ] { } \ | , . / ?).each do |char|
    context "when the html has a #{char} character after a closing tag" do
      it 'places the punctuation after the tag without any whitespace' do
        html     = "<p>Look at <strong>this</strong>#{char} More words here</p>"
        expected = "<p>Look at <strong>this</strong>#{char}...</p>"
        truncate(html, :length => 19).should == expected
      end
    end
  end

  context 'when the html has a non punctuation character after a closing tag' do
    it 'leaves a whitespace between the closing tag and the following word character' do
      html     = '<p>Look at <a href = "awesomeful.net">this</a> link for randomness</p>'
      expected = '<p>Look at <a href = "awesomeful.net">this</a> link...</p>'
      truncate(html, :length => 21).should == expected
    end
  end

  it 'handles multibyte characters and leaves them in the result' do
    html     = '<p>Look at our multibyte characters ā ž <a href = "awesomeful.net">this</a> link for randomness ā ž</p>'
    truncate(html, :length => html.length).should == html
  end

  #unusual, but just covering my ass
  it 'recognizes the multiline html properly' do
    html = <<-END_HTML
      <div id="foo"
            class="bar">
This is ugly html.
</div>
    END_HTML
    truncate(html, :length => 12).should == ' <div id="foo" class="bar"> This is...</div>'
  end

  %w(br hr img).each do |unpaired_tag|
    context "when the html contains a #{unpaired_tag} tag" do

      context "and the #{unpaired_tag} does not have the closing slash" do
        it "does not close the #{unpaired_tag} tag" do
          html      = "<div>Some before. <#{unpaired_tag}>and some after</div>"
          html_caps = "<div>Some before. <#{unpaired_tag.capitalize}>and some after</div>"
          truncate(html, :length => 19).should == "<div>Some before. <#{unpaired_tag}>and...</div>"
          truncate(html_caps, :length => 19).should == "<div>Some before. <#{unpaired_tag.capitalize}>and...</div>"
        end
      end

      context "and the #{unpaired_tag} does have the closing slash" do
        it "does not close the #{unpaired_tag} tag" do
          html      = "<div>Some before. <#{unpaired_tag} />and some after</div>"
          html_caps = "<div>Some before. <#{unpaired_tag.capitalize} />and some after</div>"
          truncate(html, :length => 19).should == "<div>Some before. <#{unpaired_tag} />and...</div>"
          truncate(html_caps, :length => 19).should == "<div>Some before. <#{unpaired_tag.capitalize} />and...</div>"
        end
      end

    end
  end

  it 'does not truncate quotes off when input contains chinese characters' do
    html = "<p>“我现在使用的是中文的拼音。”<br>
    测试一下具体的truncate<em>html功能。<br>
    “我现在使用的是中文的拼音。”<br>
    测试一下具体的truncate</em>html功能。<br>
    “我现在使用的是中文的拼音。”<br>
    测试一下具体的truncate<em>html功能。<br>
    “我现在使用的是中文的拼音。”<br>
    测试一下具体的truncate</em>html功能。</p>"

    result = truncate(html, :omission => "", :length => 50)
    result.should include "<p>“我现在使用的是中文的拼音。”<br>"
  end

  context 'when the break_token option is set as <!-- truncate -->' do
    it 'does not truncate abnormally if the break_token is not present' do
      truncate('This is line one. This is line two.', :length => 30, :break_token => '<!-- truncate -->').should == 'This is line one. This is...'
    end
    it 'does not truncate abnormally if the break_token is present, but beyond the length param' do
      truncate('This is line one. This is line <!-- truncate --> two.', :length => 30, :break_token => '<!-- truncate -->').should == 'This is line one. This is...'
    end
    it 'truncates before the length param if the break_token is before the token at "length"' do
      truncate('This is line one. <!-- truncate --> This is line two.', :length => 30, :break_token => '<!-- truncate -->').should == 'This is line one.'
    end
  end

  context 'when the break_token option is customized as a comment' do
    it 'does not truncate abnormally if the break_token is not present' do
      truncate('This is line one. This is line two.', :length => 30, :break_token => '<!-- break -->').should == 'This is line one. This is...'
    end
    it 'does not truncate abnormally if the break_token is present, but beyond the length param' do
      truncate('This is line one. This is line <!-- break --> two.', :length => 30, :break_token => '<!-- break -->').should == 'This is line one. This is...'
    end
    it 'truncates before the length param if the break_token is before the token at "length"' do
      truncate('This is line one. <!-- break --> This is line two.', :length => 30, :break_token => '<!-- break -->').should == 'This is line one.'
    end
  end

  context 'when the break_token option is customized as an html tag' do
    it 'does not truncate abnormally if the break_token is not present' do
      truncate('This is line one. This is line two.', :length => 30, :break_token => '<break />').should == 'This is line one. This is...'
    end
    it 'does not truncate abnormally if the break_token is present, but beyond the length param' do
      truncate('This is line one. This is line <break /> two.', :length => 30, :break_token => '<break />').should == 'This is line one. This is...'
    end
    it 'truncates before the length param if the break_token is before the token at "length"' do
      truncate('This is line one. <break /> This is line two.', :length => 30, :break_token => '<break />').should == 'This is line one.'
    end
  end

  context 'when the break_token option is customized as a word' do
    it 'does not truncate abnormally if the break_token is not present' do
      truncate('This is line one. This is line two.', :length => 30, :break_token => 'foobar').should == 'This is line one. This is...'
    end
    it 'does not truncate abnormally if the break_token is present, but beyond the length param' do
      truncate('This is line one. This is line foobar two.', :length => 30, :break_token => 'foobar').should == 'This is line one. This is...'
    end
    it 'truncates before the length param if the break_token is before the token at "length"' do
      truncate('This is line one. foobar This is line two.', :length => 30, :break_token => 'foobar').should == 'This is line one.'
    end
  end

  context 'a string with comments' do
    it 'does not duplicate comments (issue #32)' do
      truncate('<h1>hello <!-- stuff --> and <!-- la --> goodbye</h1>', length: 15).should ==
        '<h1>hello <!-- stuff --> and <!-- la -->...</h1>'
    end
  end
end
