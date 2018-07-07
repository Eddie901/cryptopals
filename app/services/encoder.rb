class Encoder

  # hexadecimal - a byte is two hex digits eg ff is 1111 1111 and 8a is 1000 1010

  hex     = %w{0 1 2 3 4 5 6 7 8 9 a b c d f}
  base_64 = %w{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
               a b c d e f g h i j k l m n o p q r s t u v w x y z
               0 1 2 3 4 5 6 7 8 9 / +}

  hex_hash = { "0" => 0, "1" => 1, "2" => 2, "3" => 3,
               "4" => 4, "5" => 5, "6" => 6, "7" => 7,
               "8" => 8, "9" => 9, "a" => 10, "b" => 11,
               "c" => 12, "d" => 13, "e" => 14, "f" => 15 }

  def base64_index(ch)
    base_64.index(ch)
  end

  def hex_index(ch)
    hex.index(ch)
  end

  def hex_to_base64_decode(hex)
    bin_to_base64_encode(hex_to_bin_encode(hex))
  end

  def chs_to_bin(str)
    str.unpack("C*").map { |i| i.to_s(2).rjust(8, '0') }.inject("") { |str, ch| str + ch }
  end

  def hex_to_base64_code()
    @str.unpack("C*")
  end

  def hex_to_bin_encode(hex)
    hex.unpack("a").map { |c| hex_hash[c] }.map { |i| i.to_s(2) }
  end

  def h_to_b(h)
    h.to_s(2).rjust(4, '0')
  end

    character_value_array = hex_string.unpack("C*")
  end

  def hex_to_binary(hex_string)
    # extract array of character values from hex string
    character_value_array = hex_string.unpack("C*")

    # convert back to character, map to 4-bit string and combine
    character_value_array.map{|c| c.chr}.map{|hd| h_to_b(hd.to_i)}.inject(""){|str, ch| str + ch}
  end

  def bin_to_base64(binary_string)
    raise "length must be divisible by 6!" unless binary_string.size % 6 == 0
    #chunk into blocks of 6
    arr = []
    while (!binary_string.empty?)
      arr << binary_string.slice!(0..5)
    end

    #encode
    arr2 = arr.map{|s| s.to_i(2)}.map{|i| base_64[i]}

    #combine
    arr2.inject(""){|str, ch| str + ch}
  end
end

# str.unpack("C*").map{|i| i.to_s(2).rjust(8, '0')}.inject(""){|str, ch| str + ch}
# hex_hash.map{|key, value| value.to_s(2).rjust(4, '0')}.inject(""){|str, ch| str + ch}
# 65.chr => "A"
# "A".ord => 65
# character_value_array.map{|c| c.chr} => array with hex digits
# character_value_array.map{|c| c.chr}.map{|hd| h_to_b(hd.to_i)}
# s1 = character_value_array.map{|c| c.chr}.map{|hd| h_to_b(hd.to_i)}.inject(""){|str, ch| str + ch}
# s.slice!(0..5)


character_value_array = hex_string.unpack("C*")

arr = []
while (!s1.empty?)
  arr << s1.slice!(0..5)
end
arr

arr2 = arr.map{|s| s.to_i(2)}.map{|i| base_64[i]}.inject(""){|str, ch| str + ch}

hex_string = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

base_64_string = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
base_64_string = "SSdgIGBpYGBpYGcgeWB1ciBicmFpYCBgaWBlIGEgcGBpc2BgYHVzIGB1c2hyYGBg"