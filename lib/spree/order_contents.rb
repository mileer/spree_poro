module Spree
  class OrderContents
    def add(item)
      self.line_items << item
      PromotionHandler::Cart.new(order, item).activate
      binding.pry
      # update order totals
    end
  end
end
