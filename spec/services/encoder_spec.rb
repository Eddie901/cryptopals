require "rails_helper"

RSpec.describe Encoder do

  let(:hex_string) {"49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"}
  let(:base_64_string) {"SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"}

  context "Crypto Challenge Set 1" do
    it "passes 1:1 hex to base_64 encoding" do
      e = Encoder.new

      binary_string = e.hex_to_binary(hex_string)
      expect(binary_string.size).to eq 4 * hex_string.size

      base_64 = e.binary_to_base_64(binary_string)
      expect(base_64).to eq base_64_string
    end
  end
end