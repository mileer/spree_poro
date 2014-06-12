module Spree
  class Zone
    attr_accessor :name, :members, :default_tax

    def initialize
      @members = []
      Spree::Data[:zones] ||= []
      Spree::Data[:zones] << self
    end

    def self.default_tax
      Spree::Data[:zones].find { |zone| zone.default_tax }
    end
  end
end