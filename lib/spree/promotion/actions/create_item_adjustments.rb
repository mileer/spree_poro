module Spree
  class Promotion
    module Actions
      class CreateItemAdjustments < Spree::PromotionAction
        attr_accessor :amount

        def run(order)
          order.line_items.each do |item|
            unless already_applied?(item)
              adjustment = Spree::Adjustment.new
              adjustment.source = self
              adjustment.amount = compute_amount(item)
              adjustment.adjustable = item
              item.adjustments << adjustment
              ItemAdjustments.new(item).calculate_adjustments
            end
          end
        end

        def compute_amount(item)
          -self.amount
        end

        private

          def already_applied?(item)
            item.adjustments.any? { |adjustment| adjustment.source == self }
          end
      end
    end
  end
end