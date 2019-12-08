require "rails_helper"

RSpec.describe Encoder do

  let(:data_path) { "challenge-data/" }

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
    it "passes 1:4 detect single-character xor" do
      data = File.new(data_path + "4.txt", "r")
      expect(data).to_not be nil
      e          = Encoder.new
      l, p, c, a = [0, 0, "0", ""]
      i          = 0
      while (line = data.gets)
        percentage, char, answer = e.find_key_to_xor_cipher(line.strip)
        #puts "\"#{i}\": #{sprintf("%.2f\%", percentage * 100)} #{char} : \"#{answer}\"" if percentage > 0.95
        if percentage > p
          p, c, a = [percentage, char, answer]
        end
        i += 1
      end
      data.close

      puts "The winner is: #{sprintf("%.2f\%", p * 100)} '#{c}' : \"#{a.force_encoding(Encoding::UTF_8)}\"" # encode('utf-8' or .encoding to get encoding
      expect(p).to be > 0.96
    end
    it "passes 1:5 repeated key XOR with key ICE" do
      string = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
      result = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
      e      = Encoder.new
      expect(e.repeated_key_xor_to_hex("ICE", string)).to eq result
    end
    xit "1:5 helper repeatedly encrypting using repeated-key XOR recovers the original string" do
      strings = read_lines("one_liners.txt")
      expect(strings.size).to eq 9
      keys   = ["Rachel", "Dynamo", "ICE", "Hello, World!"]#"::5^&*"]
      expect(keys.size).to eq 4
      e      = Encoder.new
      strings.each do |string|
        keys.each do |key|
          result = e.encrypt_xor(key, string).force_encoding(Encoding::UTF_8)
          puts "#String: #{string} encrypted with Key: #{key} " #gives #{result.force_encoding(Encoding::UTF_8)}"
          expect(e.encrypt_xor(key, result) == string).to be true
          puts "Success"
        end
      end
    end
    xit "1:6 prelim can convert a base_64 encoded string into binary the hex and back again" do
      base_64_samples = read_lines("base_64_samples.txt")
      expect(base_64_samples.size).to eq 10
      e  = Encoder.new
      base_64_samples.each do |base_64_str|
        bin_str = e.base_64_to_binary(base_64_str)
        hex_str = e.binary_to_hex(bin_str)
        expect(e.base_64_to_hex(base_64_str)).to eq hex_str
        expect(e.hex_to_base_64(hex_str)).to eq base_64_str
      end
    end
  end

  def read_lines(filename)
    data = File.new(data_path + filename, "r")
    expect(data).to_not be nil
    strings = []
    while (line = data.gets)
      strings << line.strip
      puts "#{line}"
    end
    data.close
    puts "Loaded #{strings.size} lines"
    strings
  end
end