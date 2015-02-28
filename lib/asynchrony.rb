require 'faraday'

class Asynchrony
  class HTTPError < StandardError; end

  DEFAULT_RETRIES = 10
  DEFAULT_WAIT_TIME = 1 #seconds

  # if you just want to try once, this will work
  def self.get(url)
    Poller.new(url).result
  end

  # if you are going to be polling the same site for multiple results,
  #+ this will give you an object to watch the site and you can call
  #+ #result or #get on it any time you need
  def self.watch(url)
    Poller.new(url)
  end
end

require 'asynchony/poller'
