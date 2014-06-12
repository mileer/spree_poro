module Spree
  class Order
    attr_accessor :line_items, :adjustments

    attr_accessor :item_total, :adjustment_total, :total, :coupon_code

    def initialize
      self.line_items = []
      self.adjustments = []
    end

    def calculate_item_total
      line_items.map(&:price).inject(&:+).to_f
    end

    def calculate_adjustment_total
      adjustments.map(&:amount).inject(&:+).to_f
    end

    def update_totals
      self.item_total = calculate_item_total
      self.adjustment_total = calculate_adjustment_total
      self.total = item_total + adjustment_total
    end

    def apply_coupon_code
      if coupon_code
        promotion = Spree::DATA[:promotions].find do |promotion|
          promotion.code == coupon_code
        end

        if promotion
          promotion.activate(self)
          update_totals
        end
      end
    end
  end
end