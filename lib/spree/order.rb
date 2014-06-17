module Spree
  class Order
    attr_accessor :line_items, :adjustments, :shipments

    attr_accessor :item_total, :adjustment_total, :promo_total, :total,
                  :included_tax_total, :additional_tax_total,
                  :coupon_code, :tax_zone, :currency

    def initialize
      self.line_items = []
      self.shipments = []
      self.adjustments = []
    end

    def calculate_item_total
      line_items.map(&:price).inject(&:+).to_f
    end

    def calculate_adjustment_total
      sum_adjustments(adjustments) + 
      sum_adjustments(line_items.map(&:adjustments).flatten)
    end

    def update_totals
      self.item_total = calculate_item_total
      self.adjustment_total = calculate_adjustment_total
      self.total = (item_total + adjustment_total).round(2)
    end

    def update_adjustments
      update_totals
      Spree::ItemAdjustments.new(self).calculate_adjustments
    end

    def all_adjustments
      self.adjustments + self.line_items.map(&:adjustments).flatten
    end

    def apply_coupon_code
      if coupon_code
        promotion = Spree::Data[:promotions].find do |promotion|
          promotion.code == coupon_code
        end

        if promotion
          promotion.activate(order: self)
          update_totals
        end
      end
    end

    def tax_zone
      @tax_zone || Zone.default_tax
    end

    def contents
      OrderContents.new(self)
    end

    private

    def sum_adjustments(adjustments)
      adjustments.map(&:amount).inject(&:+).to_f
    end
  end
end