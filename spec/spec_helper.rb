require 'pry'
require 'rspec'
require 'simplecov'
SimpleCov.start

require 'spree'
require 'active_support/core_ext/string'

module Spree
  module TestHelpers
    def create(type, attributes)
      klass = Spree.const_get(type.to_s.classify)
      record = klass.new
      attributes.each do |key, value|
        record.send("#{key}=", value)
      end
      record
    end
  end
end

RSpec.configure do |c| 
  c.include Spree::TestHelpers

  c.before do
    Spree::Data.clear
  end

end