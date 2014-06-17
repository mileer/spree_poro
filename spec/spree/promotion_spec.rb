require 'spec_helper'

module Spree
  describe Promotion do
    let(:order) { double }
    let(:action) { double('Action') }
    context 'with an eligible rule' do
      before do
        subject.rules << double('Rule', eligible?: true)
      end

      it "is eligible" do
        expect(subject.eligible?(order)).to eq(true)
      end

      context 'with an ineligible rule' do
        before do
          subject.rules << double('Rule', eligible?: false)
        end

        it "is not eligible" do
          expect(subject.eligible?(order)).to eq(false)
        end
      end
    end

    context 'with only ineligible rules' do
      before do
        subject.rules << double('Rule', eligible?: false)
      end

      it "is not eligible" do
        expect(subject.eligible?(order)).to eq(false)
      end
    end
  end
end
