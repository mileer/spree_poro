module Spree
  class LineItem
    attr_accessor :price, :adjustments, :variant, :order, 
                  :promo_total, :included_tax_total, :additional_tax_total,
                  :adjustment_total, :discounted_amount, :pre_tax_amount

    def initialize
      @adjustments = []
    end

    def tax_category
      variant.tax_category
    end
  end
end