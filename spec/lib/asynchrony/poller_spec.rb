require 'spec_helper'

module Asynchrony
  RSpec.describe Poller do
    subject { described_class.new(url) }
    let(:url)    { "http://#{junk}.com" }
    let(:result) { XmlGenerator.test_xml('InitiationResponse') }
    let(:success) do
      { status: 200, body: result }
    end
    let(:failure) do
      { status: 404, body: 'message not found' }
    end

    it 'has a customizable number of retries' do
      retries = junk(1)
      subject.retries = retries
      expect(subject.retries).to eq(retries)
    end

    it 'has a customizable minimum wait time' do
      wait_time = junk(1)
      subject.min_wait_time = wait_time
      expect(subject.min_wait_time).to eq(wait_time)
    end

    it 'has a customizable maximum wait time' do
      wait_time = junk(2)
      subject.max_wait_time = wait_time
      expect(subject.max_wait_time).to eq(wait_time)
    end

    describe '#result (or #get)' do
      context 'when the response is valid' do
        before do
          stub_request(:get, url).to_return(success)
        end

        it 'is the content of the successful response' do
          expect(subject.result.body).to eq(result)
        end
      end

      context 'when the response is an HTTP error' do
        before do
          subject.min_wait_time = 0
          stub_request(:get, url).to_return(failure, success)
        end

        it 'retries until it is successful' do
          expect(subject.result.body).to eq(result)
        end
      end

      context 'when the response is not valid (after running out of retries)' do
        before(:each) do
          subject.retries = 1
          stub_request(:get, url).to_return(failure)
        end

        it 'errors because it was unsuccessful' do
          expect { subject.get }.to raise_exception Asynchrony::HTTPError
        end
      end
    end
  end
end
