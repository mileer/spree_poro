require 'pry'
require 'rspec'
require 'simplecov'
SimpleCov.start

require 'spree'

module Spree
  module TestHelpers
    def create(type, attributes)
      # klass_name = Lotus::Utils::String.new(type).classify
      klass = Spree.const_get(klass_name)
      record = klass.new(attributes)
      klass_repository.persist(record)
    end
  end
end

RSpec.configure do |c| 
  c.include Spree::TestHelpers
end