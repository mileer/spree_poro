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
      check_promotions
      sum_adjustments(adjustments) + 
      sum_adjustments(line_items.map(&:adjustments).flatten)
    end

    # In order to get an accurate adjustment total, we must check all the individual line items
    # and their respective promotions. By the time #update_totals is called, another line item 
    # may have been added. If this happens, promotions which were once ineligible may become
    # eligible. This method makes those promotions eligible.
    #
    # An example:
    #
    # Order #1
    #   - Line Item #1 - $20
    #
    # Promotion #1
    #   - Type: Cart
    #   - Rule: Item total > $10
    #   - Action: $2.50 off each item
    #
    # Promotion #2
    #    - Type: Cart
    #   - Rule: Item total > $30
    #   - Action: $5 off each line item.
    #
    # At this point, with both promotions having already been activated on the order, only
    # Promotion #1 should be eligible, given that the order total is only $20.
    #
    # When a new item is added, this will most-certainly effect the final total. Let's say
    # another item of $20 is added to this order, making the total $40. The
    # PromotionHandler::Cart class will declare Promotion #2 the winner instantly for this
    # new item. The original item's promotions are never checked to see if their eligibility
    # changes, so therefore the adjustments look like this:
    #
    # Line Item #1
    #   - Adjustment (Promotion #1): $2.50 ELIGIBLE
    #   - Adjustment (Promotion #2): $5.00 INELIGIBLE
    # Line Item #2
    #   - Adjustment (Promotion #1): $2.50 INELIGIBLE
    #   - Adjustment (Promotion #2): $5.00 ELIGIBLE
    #
    # This method is designed to prevent cases like this by quickly recomputing each line
    # item's promotion total once more.
    def check_promotions
      line_items.each do |item|
        Spree::ItemAdjustments.new(item).calculate_promo_total
      end
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
        if promotion = find_promotion_by_coupon_code
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

    def find_promotion_by_coupon_code
      Spree::Repositories::Promotion.where(:code => coupon_code).first
    end

    def sum_adjustments(adjustments)
      adjustments.map(&:amount).inject(&:+).to_f
    end
  end
end