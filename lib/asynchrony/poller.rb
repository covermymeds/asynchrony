require 'asynchrony/specific_errors'

module Asynchrony
  class Poller
    include SpecificErrors

    attr_accessor :retries, :min_wait_time, :max_wait_time

    def initialize(url)
      @url = url
      @retries = DEFAULT_RETRIES
      @wait_time = DEFAULT_WAIT_TIME
      @max_wait_time = 2 ** @retries
      super()
    end

    def result
      with_retries(retry_criteria) do |_attempt|
        @sync_response = Faraday.get(@url)
        verify_success
        break if do_not_rescue?
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
      status < 300
    end

    def raise_http_error
      do_not_rescue! unless rescue_this_error?
      raise HTTPError, error_message
    end

    def retry_criteria
      {
        max_tries: @retries,
        base_sleep_seconds: @wait_time,
        max_sleep_seconds: @max_wait_time,
      rescue: HTTPError
      }
    end

    def error_message
      "#{status} error receiving data from #{@url}:
      #{@sync_response.body}"
    end
  end
end
