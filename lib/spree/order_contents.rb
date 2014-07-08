module Spree
  class OrderContents
    attr_accessor :order

    def initialize(order)
      @order = order
    end

    def add(item)
      order.line_items << item
      order.update_totals # adding line item effects total
      activate_cart_promotions(item)
      # might need another update totals here?
    end

    private

    def activate_cart_promotions(item)
      PromotionHandler::Cart.activate(order, item)
    end
  end
end
