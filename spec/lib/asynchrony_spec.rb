require 'spec_helper'

RSpec.describe Asynchrony do
  describe '.get' do
    it 'is the content from the url' do
      # Asynchrony.get(url)
    end

    context 'when only errors are received' do
      it 'raises an exception'
    end
  end

  describe '.watch' do
    it 'is a new Poller for the url' do
      # poller = Asynchrony.watch(url)
      # poller.get / poller.result
    end
  end
end
