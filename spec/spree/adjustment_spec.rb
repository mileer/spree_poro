require 'spec_helper'

module Spree
  describe Adjustment do
    subject { Spree::Adjustment.new(source: double('Source') ) }

    context "when open" do
      before { subject.state = 'open' }

      it "updates an adjustment" do
        expect(subject.source).to receive(:compute_amount)
        subject.update!
      end
    end

    context "when closed" do
      before { subject.state = 'closed' }
      
      it "does not update an adjustment" do
        expect(subject.source).to_not receive(:compute_amount)
        subject.update!
      end
    end
  end
end