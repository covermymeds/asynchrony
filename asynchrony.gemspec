# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asynchrony/version'

Gem::Specification.new do |s|
  s.name        = 'asynchrony'
  s.version     = Asynchrony::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Get a response to a HTTP POST that is coming asychronously'
  s.description = <<EOS
Basic approach to polling a website for an expected, asynchronous result.
Rather than the traditional approach of returning a boolean indicating
whether changes have been made, this gem expects an HTTP error code will
be given if content is not ready. Asynchrony will keep trying to GET content
until either it is successful or the number of retries is exhausted.  By
default will try 10 times and will wait in exponentially larger increments.
Both of these values can be modified.

If the retries run out and only error codes have been found, Asynchrony
will throw an error.
EOS
  s.authors     = ['Kelli Searfos']
  s.email       = 'ksearfos@covermymeds.com'
  s.homepage    = 'https://git.innova-partners.com/cover_my_meds/asynchrony'

  s.files         = `git ls-files -z`.split("\x0")
  s.require_path  = 'lib'

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'geminabox', '~> 0.12.0'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'junklet'
  s.add_development_dependency 'xml_generator'

  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'retries'
end
