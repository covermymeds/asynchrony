class AsynchronousResponse
  class HTTPError < StandardError; end

  DEFAULT_RETRIES = 10
  DEFAULT_WAIT_TIME = 1 #seconds

  attr_accessor :retries, :wait_time, :wait_calculator

  def initialize(url)
    @url = url
    @attempt = 1
    @retries = DEFAULT_RETRIES
    @wait_time = DEFAULT_WAIT_TIME
    @wait_calculator = ->{ @wait_time ** @attempt }
  end

  def result
    begin
      sleep @wait_calculator.call
      @sync_response = new_faraday_conn.get(@url.results)
      increase_count
    end until contact_successful? || out_of_tries?
    verify_success
  end

  private

  def increase_count
    @attempt += 1
  end

  def out_of_tries?
    @attempt >= @retries
  end

  def verify_success
    @sync_response.tap do
      raise_http_error unless contact_successful?
    end
  end

  def new_faraday_conn
    Faraday.new.tap do |conn|
      conn.headers['Content-Type'] = "application/#{content_type}"
      conn.headers['Accept'] = "application/#{content_type}"
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

  def content_type
    self.class.instance_variable_get(:@content_type)
  end
end
