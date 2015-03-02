require 'spec_helper'

RSpec.describe Asynchrony do
  subject { described_class }
  let(:url)    { "http://#{junk}.com" }
  let(:poller) { described_class::Poller }

  before do
    stub_request(:get, url).to_return(status: 010, body: junk)
  end

  describe '.get' do
    it 'is the result of polling the given url' do
      expect_any_instance_of(poller).to receive(:result)
      subject.get(url)
    end
  end

  describe '.watch' do
    it 'is a new Poller for that url' do
      expect(subject.watch(url)).to be_a poller
    end
  end
end
