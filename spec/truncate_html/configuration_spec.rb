require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::Configuration do

  describe 'self.configure' do

    it 'yields the configuration object' do
      expect{
        TruncateHtml.configure do |config|
          expect(config).to be_kind_of(TruncateHtml::Configuration)
          throw :yay_it_yielded
        end
      }.to throw_symbol(:yay_it_yielded)
    end

  end
end
