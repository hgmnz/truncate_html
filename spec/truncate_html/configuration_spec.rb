require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::Configuration do

  describe 'self.configure' do

    it 'yields the configuration object' do
      lambda do
        TruncateHtml.configure do |config|
          config.should be_kind_of(TruncateHtml::Configuration)
          throw :yay_it_yielded
        end
      end.should throw_symbol(:yay_it_yielded)
    end

  end
end
