module Asynchrony
  class Poller
    attr_accessor :retries, :wait_time

    def initialize(url)
      @url = url
      @attempts = 0
      @retries = DEFAULT_RETRIES
      @wait_time = DEFAULT_WAIT_TIME
    end

    def result
      begin
        sleep calculated_wait_time
        @sync_response = Faraday.get(@url)
        increase_count
      end until contact_successful? || out_of_tries?
      verify_success
    end
    alias_method :get, :result

    private

    def increase_count
      @attempts += 1
    end

    def out_of_tries?
      @attempts >= @retries
    end

    def verify_success
      @sync_response.tap do
        raise_http_error unless contact_successful?
      end
    end

    def contact_successful?
      @sync_response.status < 300
    end

    def raise_http_error
      message = "#{@sync_response.status} error communicating with #{@url}:
      #{@sync_response.body}"
      raise HTTPError, message
    end

    def calculated_wait_time
      @wait_time.call
    end
  end
end
