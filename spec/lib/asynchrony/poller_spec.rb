require 'spec_helper'

module Asynchrony
  RSpec.describe Poller do

  let(:result) { XmlGenerator.test_xml('InitiationResponse') }

  before do
    stub_request(:get, url).to_return(status: 200, body: result)
  end

  describe '#result' do
    context 'when the response is (eventually) valid' do
      it 'is the content of the successful response' do
        expect { send_request }.not_to raise_exception
      end
    end

    context 'when the response is not valid (after running out of retries)' do
      before(:each) do
        Asynchrony::NUMBER_OF_RETRIES = 0
        stub_request(:get, url).to_return(status: 404, body: 'message not found')
      end

      it 'errors because it was unsuccessful' do
        expect { send_request }.to raise_exception Asynchrony::HTTPError
      end
    end
  end
end

def send_request
  subject.send :send_request   # stupid private method calls in rspec...
end
