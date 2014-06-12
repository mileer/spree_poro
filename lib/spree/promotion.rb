module Spree
  class Promotion
    attr_accessor :code, :actions

    def initialize
      self.actions = []

      Spree::DATA[:promotions] ||= []
      Spree::DATA[:promotions] << self
    end

    def activate(order)
      self.actions.each { |a| a.run(order) }
    end
  end
end