module Spree
  class Promotion
    module Actions
      class CreateLineItemAdjustment < Spree::PromotionAction
        attr_accessor :amount

        def run(order)
          order.line_items.each do |item|
            item.price = (item.price - self.amount).round(2)
          end
        end
      end
    end
  end
end