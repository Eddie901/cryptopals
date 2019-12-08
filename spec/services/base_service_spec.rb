require "rails_helper"

RSpec.describe BaseService do
  let(:data) { { a: 1 } }

  subject { described_class.new(data).call }

  describe '#call' do
    it "returns the input data" do
      expect(subject).to eq data
    end
  end
end