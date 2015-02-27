require 'rspec'
require 'junklet'
require 'cover_my_epa'

Dir[CoverMyEpa.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.color = :enabled
  config.fail_fast = true
  config.formatter = :documentation
end
