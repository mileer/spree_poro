  require 'spec_helper'

module Spree
  describe TaxRate do
    let!(:order) { Spree::Order.new }
    let!(:usa_zone) do
      zone = Spree::Zone.new
      zone.name = 'USA'
      usa = Spree::Country.new
      zone.members << usa
      zone.default_tax = true
      zone
    end

    let!(:eu_zone) do
      zone = Spree::Zone.new
      zone.name = 'EU'
      france = Spree::Country.new
      zone.members << france
      zone.default_tax = false
      zone
    end

    let!(:aus_zone) do
      zone = Spree::Zone.new
      zone.name = 'Australia'
      australia = Spree::Country.new
      zone.members << australia
      zone.default_tax = false
      zone
    end

    let!(:clothing_category) do
      tax_category = Spree::TaxCategory.new
      tax_category.name = "Clothing"
      tax_category
    end

    let!(:food_category) do
      tax_category = Spree::TaxCategory.new
      tax_category.name = "Food"
      tax_category
    end

    let!(:usa_tax_rate) do
      tax_rate = Spree::TaxRate.new
      tax_rate.name = "USA 10%"
      tax_rate.included_in_price = false
      tax_rate.amount = 0.1
      tax_rate.tax_category = clothing_category
      clothing_category.tax_rates << tax_rate
      tax_rate.zone = usa_zone
      tax_rate
    end

    let!(:eu_tax_rate) do
      tax_rate = Spree::TaxRate.new
      tax_rate.name = "EUR 5%"
      tax_rate.included_in_price = true
      tax_rate.amount = 0.05
      tax_rate.tax_category = clothing_category
      clothing_category.tax_rates << tax_rate
      tax_rate.zone = eu_zone
      tax_rate
    end

    context "match" do
      context "with USA zone as default tax zone" do
        before do
          usa_zone.default_tax = true
        end

        it "picks USA tax rates" do
          rates = Spree::TaxRate.match(order)
          expect(rates).to include(usa_tax_rate)
          expect(rates).to_not include(eu_tax_rate)
        end
      end

      context "based on order tax zone" do
        before do
          order.tax_zone = eu_tax_rate
        end

        it "returns both rates" do
          rates = Spree::TaxRate.match(order)
          expect(rates).to include(usa_tax_rate)
          expect(rates).to_not include(eu_tax_rate)
        end
      end
    end

    context ".adjust" do
      before do
        product = Spree::Product.new
        variant = Spree::Variant.new
        variant.product = product
        product.master = variant
        product.tax_category = clothing_category

        line_item = Spree::LineItem.new
        line_item.price = 10
        line_item.variant = variant
        order.line_items << line_item
      end

      it "adds 10% default tax for the order's line item" do
        Spree::TaxRate.adjust(order)
        expect(order.line_items.first.adjustments.count).to eq(1)
        adjustment = order.line_items.first.adjustments.first
        expect(adjustment.amount).to eq(1) # = 10% of $10.
        expect(adjustment.included).to eq(false)
      end

      context "with a line item with a different tax category" do
        before do
          order.line_items.first.variant.product.tax_category = food_category
        end

        it "does not apply an adjustment" do
          Spree::TaxRate.adjust(order)
          expect(order.line_items.first.adjustments.count).to eq(0)
        end
      end

      context "in the EU zone" do
        before do
          order.tax_zone = eu_zone
        end

        it "includes 5% tax for the order's line item" do
          Spree::TaxRate.adjust(order)
          expect(order.line_items.first.adjustments.count).to eq(1)
          adjustment = order.line_items.first.adjustments.first
          expect(adjustment.amount).to eq(0.48) # 10 - ( 10 / (1 + 5%  ) ) = 0.476, but we round to 2.
          expect(adjustment.included).to eq(true)
        end
      end

      context "with an order for an AU customer" do
        before do
          order.tax_zone = aus_zone
        end
        
        # Tax rate is additional, so it makes no sense to refund a tax that hasn't been applied yet!
        it "applies no tax adjustment at all" do
          Spree::TaxRate.adjust(order)
          expect(order.line_items.first.adjustments.count).to eq(0)
        end
      end

      context "with EUR zone as the default" do
        before do
          usa_zone.default_tax = false
          eu_zone.default_tax = true
        end

        context "with an order for a USA customer" do
          before do
            order.tax_zone = usa_zone
          end

          it "applies the 10% tax from the US" do
            Spree::TaxRate.adjust(order)
            expect(order.line_items.first.adjustments.count).to eq(1)
            adjustment = order.line_items.first.adjustments.first
            expect(adjustment.amount).to eq(1) #10% of $10.
            expect(adjustment.included).to eq(false)
          end
        end

        context "with an order for a AUS customer" do
          before do
            order.tax_zone = aus_zone
          end

          it "applies the 5% tax refund from EUR" do
            Spree::TaxRate.adjust(order)
            expect(order.line_items.first.adjustments.count).to eq(1)
            adjustment = order.line_items.first.adjustments.first
            expect(adjustment.amount).to eq(-0.48) # 10 - ( 10 / (1 + 5%  ) ) = 0.476, but we round to 2.
            expect(adjustment.included).to eq(false)
          end
        end
      end
    end 
  end
end