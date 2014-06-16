module Spree
  class Promotion
    module Rules
      class ItemTotal
        attr_accessor :threshold

        def eligible?(order)
          order.item_total >= threshold
        end
      end
    end
  end
end