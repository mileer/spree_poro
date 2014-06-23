require 'active_support/core_ext/object/blank'

module Spree
  class Adjustment
    attr_accessor :amount, :source, :included, :eligible, :adjustable, :label, :state

    def eligible?
      !!@eligible
    end

    def closed?
      state == 'closed'
    end

    def determine_eligibility
      if promotion?
        self.eligible = source.promotion.eligible?(adjustable)
      end
    end

    def update!(target = nil)
      return amount if closed?
      if source.present?
        amount = source.compute_amount(target || adjustable)
        self.amount = amount
        determine_eligibility
      end
      amount
    end

    private

    def promotion?
      Spree::PromotionAction === self.source
    end
  end
end