module Spree
  class ProductSerializer < ActiveModel::Serializer
    attributes :id, :name
    has_one :tax_category
  end
end
