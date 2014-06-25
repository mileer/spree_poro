require 'spec_helper'

module Spree
  describe ProductSerializer do
    let(:product) { Spree::Product.new(name: "T-Shirt") }

    subject { Spree::ProductSerializer.new(product) }

    it "can serialize a product to JSON" do
      expect(JSON.parse(subject.to_json)).to eq(
        {
          "id" => nil,
          "name" => product.name
        }
      )
    end
  end
end