require 'spec_helper'

module Spree
  describe ProductRepository do
    let(:product) { Spree::Product.new(name: "T-Shirt", tax_category: { name: 'Default' } ) }

    it "storing sets the ID" do
      expect(product.id).to be_nil
      Spree::ProductRepository.store(product)
      expect(product.id).to_not be_nil
    end

    it "can store and get a product" do
      Spree::ProductRepository.store(product)
      new_product = Spree::ProductRepository.get(product.id)

      expect(new_product).to_not be_nil
      expect(new_product.id).to eq(product.id)

      expect(new_product.tax_category.name).to eq 'Default'
    end
  end
end
