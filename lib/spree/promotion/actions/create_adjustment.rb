module Spree
  class Promotion
    module Actions
      class CreateAdjustment < Spree::PromotionAction
        attr_accessor :amount

        def run(order)
          adjustment = Spree::Adjustment.new
          adjustment.source = self
          adjustment.amount = compute_amount(order)
          adjustment.adjustable = order
          order.adjustments << adjustment
          adjustment.determine_eligibility
        end

        def compute_amount(order)
          -self.amount
        end
      end
    end
  end
end