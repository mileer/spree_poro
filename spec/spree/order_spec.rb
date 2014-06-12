require 'spec_helper'
require 'spree'

module Spree
  describe Order do
    it "can have line items" do
      subject.line_items = [Spree::LineItem.new]
      expect(subject.line_items.count).to eq(1)
    end

    context "#update_totals" do
      context "with a line item" do
        before do
          item = Spree::LineItem.new
          item.price = 19.99
          subject.line_items = [item]
        end

        it "sets the total" do
          subject.update_totals
          expect(subject.total).to eq(19.99)
        end
      end
    end

    context "#apply_coupon_code" do
      let(:code) { "10off" }

      before do 
        item = Spree::LineItem.new
        item.price = 19.99
        subject.line_items = [item]
        subject.update_totals

        promotion = Promotion.new
        promotion.code = code
        action = Spree::Promotion::Actions::CreateLineItemAdjustment.new
        action.amount = 10
        promotion.actions << action
        subject.coupon_code = code
      end

      it "applies the coupon code" do
        expect(subject.total).to eq(19.99)
        subject.apply_coupon_code
        expect(subject.total).to eq(9.99)
      end

      it "does not apply the code if none set" do
        subject.coupon_code = nil
        expect(subject.total).to eq(19.99)
        subject.apply_coupon_code
        expect(subject.total).to eq(19.99)
      end
    end
  end
end