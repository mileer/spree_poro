require 'bigdecimal'

module Spree
  class TaxRate
    attr_accessor :tax_category, :name, :zone, :amount, :included_in_price, :currency

    def initialize
      Spree::Data[:tax_rates] ||= []
      Spree::Data[:tax_rates] << self
    end

    def self.match(order)
      Spree::Data[:tax_rates].select do |rate|
        # Rates are excluded based on currency because of this:
        # If you have a product priced in $10 USD, then it should be taxed at the USD rate.
        # If someone buys that $10 USD product and they're not from a US tax zone, no tax rate applies.
        # If that product is sold at $10 AUD instead, then the AUD tax rate should apply for that item, if there is one.
        rate.currency == order.currency && (rate.zone == order.tax_zone || rate.zone == Zone.default_tax)
      end
    end

    def self.adjust(order)
      if order.tax_zone
        rates = self.match(order)

        # If there is a rate that matches this zone, then default tax zone does not apply.
        # In this case, we will only need to apply the tax rates that aren't from the default.
        #
        # If *only* the default tax zone is returned then one of two things can happen:
        # 1) The order's tax_zone matches default zone by way of it being the default.
        #    In this case, a *positive* adjustment is applied.
        # 2) The order's tax_zone does not match the default zone, and does not match any other tax zone.
        #    In this case, a *negative* adjustment (refund) is applied.
        if rates.count > 1
          rates.delete_if { |rate| rate.zone == Zone.default_tax }
        end

        rates.each do |rate|
          rate.adjust(order)
        end
      end
    end

    def compute(line_item)
      if included_in_price
        deduced_total_by_rate(line_item.price, self)
      else
        round_to_two_places(line_item.price * amount)
      end
    end

    def round_to_two_places(amount)
      BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
    end

    def deduced_total_by_rate(total, rate)
      round_to_two_places(total - ( total / (1 + rate.amount) ) )
    end

    def adjust(order)
      if self.zone == Zone.default_tax && order.tax_zone == Zone.default_tax
        apply_tax_adjustment(order)
      elsif self.zone == order.tax_zone # should be a contains? check, but I am lazy
        apply_tax_adjustment(order)
      elsif Zone.default_tax && self.included_in_price
        apply_refund(order)
      end
    end

    private

    def apply_tax_adjustment(order)
      order.line_items.each do |item|
        if item.tax_category == tax_category
          adjustment = Spree::Adjustment.new
          adjustment.amount = compute(item)
          adjustment.included = self.included_in_price
          item.adjustments << adjustment
        end
      end
    end

    def apply_refund(order)
      order.line_items.each do |item|
        if item.tax_category == tax_category
          adjustment = Spree::Adjustment.new
          adjustment.amount = -compute(item)
          adjustment.included = false
          item.adjustments << adjustment
        end
      end
    end
  end
end