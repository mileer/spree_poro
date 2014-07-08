module Spree
  module PromotionHandler
    class Cart
      def self.activate(order, line_item=nil)
        promotions.each do |promotion|
          if (line_item && promotion.eligible?(line_item)) || promotion.eligible?(order)
            promotion.activate(line_item: line_item, order: order)
          end
        end
      end

      private

      def self.promotions
        Spree::Repositories::Promotion.where(:code => nil)
      end
    end
  end
end
