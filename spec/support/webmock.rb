require 'webmock/rspec'

if ENV['WEBMOCK_ENABLE_CONNECT']
  WebMock.allow_net_connect!
else
  WebMock.disable_net_connect!
end
