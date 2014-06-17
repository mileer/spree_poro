require 'active_support/core_ext/object/blank'

module Spree
  class Adjustment
    attr_accessor :amount, :source, :included, :eligible, :adjustable, :label

    def eligible?
      !!@eligible
    end

    def update!(target = nil)
      # return amount if closed?
      if source.present?
        amount = source.compute_amount(target || adjustable)
        self.amount = amount
        if promotion?
          self.eligible = source.promotion.eligible?(adjustable)
        end
      end
      amount
    end

    private

    def promotion?
      Spree::PromotionAction === self.source
    end
  end
end