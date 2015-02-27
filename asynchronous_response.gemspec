# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asynchronous_response/version'

Gem::Specification.new do |s|
  s.name        = 'AsynchronousResponse'
  s.version     = AsynchronousResponse::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Retrieve a response to a HTTP POST that is coming asychronously"
  s.description =<<EOS
Simple framework to define a website to observe, and callout to the website until
a response comes back that is not an error message.  Designates a finite number
of retries until it gives up and a specific amount of time to wait between
GETS, both of which are configurable.
EOS
  s.authors     = ["Kelli Searfos"]
  s.email       = 'ksearfos@covermymeds.com'
  s.files       = ["lib/asynchronous_response.rb"]
  s.homepage    = 'https://git.innova-partners.com/cover_my_meds/asynchronous_response'

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'junklet'
  s.add_development_dependency 'xml_generator'

  s.add_runtime_dependency 'faraday'
end
