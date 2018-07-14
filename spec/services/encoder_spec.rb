require "rails_helper"

RSpec.describe Encoder do

  context "Crypto Challenge Set 1" do
    it "passes 1:1 hex to base_64 encoding" do
      hex_string     = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
      base_64_string = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

      e = Encoder.new

      binary_string = e.hex_to_binary(hex_string)
      expect(binary_string.size).to eq 4 * hex_string.size

      base_64 = e.binary_to_base_64(binary_string)
      expect(base_64).to eq base_64_string
    end

    it "passes 1:2 fixed xor" do
      hex_string_1 = "1c0111001f010100061a024b53535009181c"
      hex_string_2 = "686974207468652062756c6c277320657965"
      hex_string_3 = "746865206b696420646f6e277420706c6179"

      e = Encoder.new

      expect(e.fixed_xor(hex_string_1, hex_string_2)).to eq hex_string_3
    end
    it "passes 1:3 single-byte xor cipher" do
      hex_string = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
      # find the character that decodes the cipher which has been xor-ed with it

      e = Encoder.new

      percentage, char, answer = e.find_key_to_xor_cipher(hex_string)

      expect(percentage).to be >= 0.75
      expect(char).to eq "X"
      puts answer
    end
  end
end