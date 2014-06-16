module Spree
  class Shipment
    attr_accessor :cost, :discounted_cost, :order, :tax_category, :adjustments, :pre_tax_amount

    def initialize
      @adjustments ||= []
    end

    def discounted_amount
      discounted_cost
    end
  end
end