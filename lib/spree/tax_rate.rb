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
        rate.currency == order.currency && (rate.zone.contains?(order.tax_zone) || rate.zone == Zone.default_tax)
      end
    end

    # Pre-tax amounts must be stored so that we can calculate
    # correct rate amounts in the future. For example:
    # https://github.com/spree/spree/issues/4318#issuecomment-34723428
    def self.store_pre_tax_amount(item, rates)
      if rates.any?(&:included_in_price)
        rate_total = rates.map(&:amount).inject(&:+)
        item.pre_tax_amount = item.discounted_amount / (1 + rate_total)
      end
    end

    def self.adjust(order, items)
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

        items.each do |item|
          store_pre_tax_amount(item, rates)
        end

        rates.each do |rate|
          rate.adjust(items)
        end
      end
    end

    def compute_amount(item)
      computed_amount = if included_in_price
        deduced_total_by_rate(item.pre_tax_amount, self)
      else
        round_to_two_places(item.discounted_amount * amount)
      end

      correct_amount_for_zone(item, computed_amount)
    end

    def adjust(items)
      items.each do |item|
        amount = compute_amount(item)
        return if amount == 0
        if item.tax_category == tax_category
          adjustment = Spree::Adjustment.new
          adjustment.amount = amount
          adjustment.included = amount < 0 ? false : self.included_in_price
          item.adjustments << adjustment
        end
      end
    end

    private

    def round_to_two_places(amount)
      BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
    end

    def deduced_total_by_rate(total, rate)
      ((rate.amount * 100) * total) / 100
    end

    def correct_amount_for_zone(item, amount)
      order = item.order
      if (self.zone == Zone.default_tax && order.tax_zone == Zone.default_tax) || self.zone.contains?(order.tax_zone)
        amount
      elsif Zone.default_tax && self.included_in_price
        -amount
      else
        0
      end
    end
  end
end