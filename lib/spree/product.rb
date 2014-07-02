module Spree
  class Product
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::SerializerSupport

    attribute :id, Integer
    attribute :name, String
    attribute :tax_category, TaxCategory

  end
end
