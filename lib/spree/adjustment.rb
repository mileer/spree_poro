module Spree
  class Adjustment
    attr_accessor :amount, :source, :included, :eligible, :adjustable, :label, :state

    def eligible?
      !!@eligible
    end

    def closed?
      state == 'closed'
    end

    def update!(target = nil)
      return amount if closed?
      if source
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