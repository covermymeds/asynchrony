require 'rspec'
require 'junklet'
require 'xml_generator'
require 'asynchrony'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.color = :enabled
  config.fail_fast = true
  config.formatter = :documentation
end
