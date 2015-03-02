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

    describe 'error codes to rescue' do
      let(:error_codes) { subject.instance_variable_get(:@rescuable_errors) }

      it 'is all of them by default' do
        expect(error_codes).to eq SpecificErrors::ALL_ERROR_CODES.to_a
      end

      it 'is customizable' do
        errors = [400, 404, 500]
        subject.rescue(*errors)
        expect(error_codes).to eq(errors)
      end
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

      context 'when the response has an HTTP error code' do
        before do
          stub_request(:get, url).to_return(failure, success)
        end

        context 'when one of the rescuable error codes is encountered' do
          it 'retries until it is successful' do
            expect(Faraday).to receive(:get).with(url).twice.and_call_original
            expect(subject.result.body).to eq(result)
          end

          context 'when it runs out of retries' do
            before(:each) do
              subject.retries = 1
              stub_request(:get, url).to_return(failure)
            end

            it 'errors because it was unsuccessful' do
              expect { subject.get }.to raise_exception Asynchrony::HTTPError
            end
          end
        end

        context 'when an error code is encountered that is not meant to be rescued' do
          before(:each) do
            subject.rescue 500
          end

          it 'stops retrying' do
            allow(subject).to receive(:raise_http_error)
            expect(Faraday).to receive(:get).with(url).once.and_call_original
            subject.get
          end

          it 'errors because it was unsuccessful' do
            expect { subject.get }.to raise_exception(/\d{3} error receiving data/)
          end
        end
      end
    end
  end
end
