require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml do
  it "includes itself in ActionController::Base" do
    expect(ActionController::Base).to receive(:helper).with(TruncateHtmlHelper)
    load File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'truncate_html.rb'))
  end

  it "does not error if ActionController is undefined" do
    hide_const("ActionController")
    expect {
      load File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'truncate_html.rb'))
    }.not_to raise_error
  end
end
