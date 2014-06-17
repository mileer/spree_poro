module Spree
  class Promotion
    module Rules
      class ItemTotal
        attr_accessor :threshold

        def eligible?(item)
          order = Spree::Order === item ? item : item.order
          order.item_total >= threshold
        end
      end
    end
  end
end