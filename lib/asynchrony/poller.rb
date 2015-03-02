module Asynchrony
  class Poller
    attr_accessor :retries, :min_wait_time, :max_wait_time

    def initialize(url)
      @url = url
      @retries = DEFAULT_RETRIES
      @min_wait_time = DEFAULT_WAIT_TIME
      @max_wait_time = @min_wait_time * @retries
    end

    def result
      with_retries(retry_criteria) do |_attempt|
        @sync_response = Faraday.get(@url)
        verify_success
      end
    end
    alias_method :get, :result

    private

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

    def retry_criteria
      {
        max_tries: @retries,
        base_sleep_seconds: @wait_time,
        max_sleep_seconds: @max_wait_time,
        rescue: HTTPError
      }
    end
  end
end
