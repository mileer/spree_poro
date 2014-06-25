module Spree
  class Product
    include Virtus.model

    attribute :id, Integer
    attribute :name, String

    attr_accessor :tax_category
  end
end