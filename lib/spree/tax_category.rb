module Spree
  class TaxCategory
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::SerializerSupport

    attribute :name, String
  end
end
