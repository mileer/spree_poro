require 'rspec'
require 'simplecov'
SimpleCov.start

require 'spree'

RSpec.configure do |c| 
  c.before do
    Spree::Data.clear
  end

end