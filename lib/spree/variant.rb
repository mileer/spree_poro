module Spree
  class Variant
    attr_accessor :product

    def tax_category
      product.tax_category
    end
  end
end