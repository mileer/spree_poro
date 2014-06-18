require 'spec_helper'

module Spree
  describe OrderContents do
    let(:item) { Spree::LineItem.new }
    let(:order) { Spree::Order.new }

    subject { Spree::OrderContents.new(order) }

    it "adds a line item" do
      expect { subject.add(item) }.to change { order.line_items.count }.from(0).to(1)
    end

    it "activates cart promotions" do
      expect(subject).to receive(:activate_cart_promotions).with(item)
      subject.add(item)
    end
  end
end