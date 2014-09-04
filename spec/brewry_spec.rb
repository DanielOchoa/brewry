require 'spec_helper'

describe Brewry do

  before(:all) do
    # How does xxx work? With VCR cassetes created with a real api key...
    Brewry.api_key = 'xxx'
  end

  context 'return types', :vcr do

    subject(:results) {  Brewry.search_beers(name: 'Lone Star') }
    subject(:no_results) { Brewry.search_beers(name: 'Corona')  }

    it 'should be an array' do
      expect(results.kind_of?(Array)).to eq(true)
    end

    it 'should return nil when no results found' do
      expect(no_results).to eq(nil)
    end

  end

  context 'api endpoints', :vcr do

    # Styles #
    it 'should search styles' do
      expect(Brewry.search_styles[0][:guid]).to eq(1)
    end

    # Brewery by name
    it 'should return brewery' do
      expect(Brewry.search_breweries(name: 'Karbach Brewing Company')[0][:name]).to eq('Karbach Brewing Company')
    end
  end

  context 'settings' do
    it 'should raise a MissingApiKey exception when no api key is set' do
      Brewry.api_key = nil
      expect { Brewry.search_beers(name: 'Lone Star') }.
        to raise_error(Brewry::MissingApiKey)
    end
  end
end
