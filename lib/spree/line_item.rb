module Spree
  class LineItem
    attr_accessor :price, :adjustments, :variant, :order, 
                  :promo_total, :included_tax_total, :additional_tax_total,
                  :adjustment_total, :pre_tax_amount

    def initialize
      @adjustments = []
    end

    def tax_category
      variant.tax_category
    end

    def discounted_amount
      price + promo_total.to_f
    end
  end
end