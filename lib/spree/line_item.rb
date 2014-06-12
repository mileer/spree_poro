module Spree
  class LineItem
    attr_accessor :price, :adjustments, :variant

    def initialize
      @adjustments = []
    end

    def tax_category
      variant.tax_category
    end
  end
end