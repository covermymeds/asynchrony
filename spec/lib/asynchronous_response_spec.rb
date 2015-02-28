# assumes url and request_json have been defined
shared_examples 'it can POST to/GET from Mock EHR' do
  let(:result) { XmlGenerator.test_xml('InitiationResponse') }

  before do
    allow(CoverMyEpa).to receive(:receive_response)

    stub_request(:post, url.request).to_return(status: 200, body: 'OK')
    stub_request(:get, url.results).to_return(status: 200, body: result)
  end

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

  describe 'necessary values' do
    before do
      allow(subject).to receive(:post)
      send_request
    end

    describe '@url' do
      it 'is the location to send instructions' do
        expect(subject.instance_variable_get(:@url).request).to eq(url.request)
      end

      it 'is the location to retrieve results' do
        expect(subject.instance_variable_get(:@url).results).to eq(url.results)
      end
    end

    describe '@body' do
      it 'is the xml to send' do
        expect(subject.instance_variable_get(:@body)).not_to be_nil
      end
    end
  end

  describe '#send_request' do
    describe 'posting the request' do
      context 'when the message is valid' do
        it 'knows that the message was successfully sent' do
          expect { send_request }.not_to raise_exception
        end
      end

      context 'when the message is invalid' do
        before(:each) do
          stub_request(:post, url.request).to_return(status: 900, body: 'FAAAAAIIIILLLLL')
        end

        it 'knows that the message was not successfully sent' do
          expect { send_request }.to raise_exception CoverMyEpa::HTTPError
        end
      end
    end

    describe 'getting the response' do
      context 'when the response is (eventually) valid' do
        it 'receives the response' do
          expect { send_request }.not_to raise_exception
        end
      end

      context 'when the response is not valid (before running out of retries)' do
        before(:each) do
          CoverMyEpa::EhrPosting::NUMBER_OF_RETRIES = 0
          stub_request(:get, url.results).to_return(status: 404, body: 'message not found')
        end

        it 'errors because it did not receive a response' do
          expect { send_request }.to raise_exception CoverMyEpa::HTTPError
        end
      end
    end

    describe 'the response' do
      before(:each) do
        stub_request(:post, url.request).to_return(status: 200, body: 'OK')
        stub_request(:get, url.results).to_return(status: 200, body: result)
        allow(CoverMyEpa).to receive(:receive_response)
      end

      it 'passes the response back to the test' do
        expect(CoverMyEpa).to receive(:receive_response).with(result)
        send_request
      end
    end
  end

  def send_request
    subject.send :send_request   # stupid private method calls in rspec...
  end
end
