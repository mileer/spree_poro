module Spree
  class ProductSerializer
    attr_accessor :object

    def initialize(object)
      @object = object
    end

    def to_json
      JSON.dump({
        id: object.id,
        name: object.name
      })
    end
  end
end