require 'spec_helper'

module Spree
  module PromotionHandler
    describe Cart do
      let(:line_item) do
        Spree::LineItem.new
      end

      let(:order) do
        order = Spree::Order.new
        order.line_items << line_item
        order
      end

      let(:promotion) do
        Spree::Promotion.new
      end

      before do
        allow(described_class).to receive(:promotions).and_return([promotion])
      end

      context "activates in LineItem level" do
        let!(:action) do
          action = Spree::Promotion::Actions::CreateItemAdjustments.new
          action.amount = 5
          action.promotion = promotion
          promotion.actions << action
          action
        end

        let(:adjustable) { line_item }

        it "creates the adjustment" do
          expect {
            described_class.activate(order, line_item)
          }.to change { adjustable.adjustments.count }.by(1)
        end
      end

      context "activates in Order level" do
        let!(:action) do
          action = Spree::Promotion::Actions::CreateAdjustment.new
          action.amount = 5
          action.promotion = promotion
          promotion.actions << action
          action
        end

        let(:adjustable) { order }

        it "creates the adjustment" do
          expect {
            described_class.activate(order, line_item)
          }.to change { adjustable.adjustments.count }.by(1)
        end
      end
    end
  end
end
