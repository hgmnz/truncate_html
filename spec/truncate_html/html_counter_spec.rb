# Encoding: UTF-8
require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlCounter do

  def count(html)
    html_string = TruncateHtml::HtmlString.new(html)
    TruncateHtml::HtmlCounter.new(html_string).count
  end

  it "it counts a string with no html" do
    count("test this shit").should == 14
  end

  it 'supports empty string' do
    lambda { count('') }.should_not raise_error
  end

  it 'treats script tags as strings with no length' do
    html = "<p>I have a script <script type = text/javascript>document.write('lum dee dum');</script> and more text</p>"
    count(html).should == 30
  end

  it 'counts a string with a lot of tags' do
    html = '<div><ul><li>Look at <a href = "foo">this</a> link </li></ul></div>'
    count(html).should == 18
  end
end
