require 'spec_helper'

module Spree
  class Promotion
    module Rules
      describe ItemTotal do
        let(:order) { Spree::Order.new }

        subject do 
          rule = Spree::Promotion::Rules::ItemTotal.new
          rule.threshold = 100
          rule
        end


        it "is eligible if equal to threshold" do
          order.item_total = 100
          expect(subject.eligible?(order)).to be_truthy
        end

        it "is eligible if above threshold" do
          order.item_total = 101
          expect(subject.eligible?(order)).to be_truthy
        end

        it "is ineligible if below threshold" do
          order.item_total = 99
          expect(subject.eligible?(order)).to be_falsey
        end
      end
    end
  end
end

