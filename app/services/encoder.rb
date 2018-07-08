class Encoder

  # hexadecimal - a byte is two hex digits eg ff is 1111 1111 and 8a is 1000 1010

  HEX_CHARACTERS     = %w{0 1 2 3 4 5 6 7 8 9 a b c d e f}
  BASE_64_CHARACTERS = %w{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
                          a b c d e f g h i j k l m n o p q r s t u v w x y z
                          0 1 2 3 4 5 6 7 8 9 / +}

  def get_base_64_index(ch)
    Encoder::BASE_64_CHARACTERS.index(ch)
  end

  def get_hex_index(ch)
    Encoder::HEX_CHARACTERS.index(ch)
  end

  def to_binary(i, n = 4)
    raise "integer #{i} to big for #{n}-digit binary" unless i < 2 ** n
    i.to_s(2).rjust(n, '0')
  end

  def string_to_array(str)
    str.each_char.to_a
  end

  def arr_to_bin(arr)
    arr.map { |i| to_bin(hex(i)) }.inject("") { |str, ch| str + ch }
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

  def hex_array_to_bin_array(arr)
    arr.map { |ch| hex_hash[ch] }.map { |i| i.to_s(2).rjust(4, '0') }
  end

  def merg_strings(arr)
    arr.inject("") { |str, ch| str + ch }
  end

  def hex_to_binary(hex_string)
    # extract array of character values from hex string
    # find hex character index, map to 4-bit string and combine
    bit_string = string_to_array(hex_string).map { |c| to_binary(get_hex_index(c)) }.inject("") { |str, ch| str + ch }
  end

  def binary_to_base_64(binary_string)
    raise "length must be divisible by 6!" unless binary_string.size % 6 == 0
    bin_str = binary_string.dup
    #chunk into blocks of 6
    arr = []
    while (!bin_str.empty?)
      arr << bin_str.slice!(0..5)
    end

    #encode and combine into one string
    arr2 = arr.map { |s| s.to_i(2) }.map { |i| BASE_64_CHARACTERS[i] }.inject("") { |str, ch| str + ch }
  end
end
#
# # str.unpack("C*").map{|i| i.to_s(2).rjust(8, '0')}.inject(""){|str, ch| str + ch}
# # hex_hash.map{|key, value| value.to_s(2).rjust(4, '0')}.inject(""){|str, ch| str + ch}
# # 65.chr => "A"
# # "A".ord => 65
# # character_value_array.map{|c| c.chr} => array with hex digits
# # character_value_array.map{|c| c.chr}.map{|hd| h_to_b(hd.to_i)}
