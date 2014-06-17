require 'spec_helper'

module Spree
  class Promotion
    module Rules
      describe ItemTotal do
        subject do 
          rule = Spree::Promotion::Rules::ItemTotal.new
          rule.threshold = 100
          rule
        end

        let(:order) { Spree::Order.new }

        shared_examples "eligibility checks" do
          it "is eligible if item total equal to threshold" do
            order.item_total = 100
            expect(subject.eligible?(item)).to be_truthy
          end

          it "is eligible if item total above threshold" do
            order.item_total = 101
            expect(subject.eligible?(item)).to be_truthy
          end

          it "is ineligible if item total below threshold" do
            order.item_total = 99
            expect(subject.eligible?(item)).to be_falsey
          end
        end

        context "when receiving an order" do
          let(:item) { order }

          it_behaves_like "eligibility checks"
        end

        context "when receiving a line item" do
          let(:item) do
            item = Spree::LineItem.new
            item.order = order
            item
          end

          it_behaves_like "eligibility checks"
        end
      end
    end
  end
end

