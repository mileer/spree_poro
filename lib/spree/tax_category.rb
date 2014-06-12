module Spree
  class TaxCategory
    attr_accessor :tax_rates, :name

    def initialize
      @tax_rates = []
    end
  end
end