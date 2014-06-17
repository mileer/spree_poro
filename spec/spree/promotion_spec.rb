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

      context "#activate" do
        before do
          subject.actions << action
        end

        it "runs the actions" do
          expect(action).to receive(:run)
          subject.activate(order)
        end
      end

      context 'with an ineligible rule' do
        before do
          subject.rules << double('Rule', eligible?: false)
        end

        it "is not eligible" do
          expect(subject.eligible?(order)).to eq(false)
        end

        context "#activate" do
          before do
            subject.actions << action
          end

          it "does not run the actions" do
            expect(action).to_not receive(:run)
            subject.activate(order)
          end
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

      context "#activate" do
        before do
          subject.actions << action
        end

        it "does not run the actions" do
          expect(action).to_not receive(:run)
          subject.activate(order)
        end
      end
    end

  end
end
