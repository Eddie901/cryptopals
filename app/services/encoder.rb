class Encoder

  # hexadecimal - a byte is two hex digits eg ff is 1111 1111 and 8a is 1000 1010

  HEX_CHARACTERS     = %w{0 1 2 3 4 5 6 7 8 9 a b c d e f}
  BASE_64_CHARACTERS = %w{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
                          a b c d e f g h i j k l m n o p q r s t u v w x y z
                          0 1 2 3 4 5 6 7 8 9 / +}
  VOWELS             = %w{a e i o u A E I O U}
  CONSONANTS         = %w{b c d f g h j k l m n p q r s t v w x y z
                          B C D F G H J K L M N P Q R S T V W X Y Z}

  def get_base_64_index(ch)
    Encoder::BASE_64_CHARACTERS.index(ch)
  end

  def get_hex_index(ch)
    Encoder::HEX_CHARACTERS.index(ch)
  end

  def int_to_binary(i, n = 4)
    raise "integer #{i} to big for #{n}-digit binary" unless i < 2 ** n
    i.to_s(2).rjust(n, '0')
  end

  def string_to_array(str)
    str.each_char.to_a
  end

  def hex_to_base_64(hex)
    binary_to_base_64(hex_to_binary(hex))
  end

  def base_64_to_hex(base_64_str)
    binary_to_hex(base_64_to_binary(base_64_str))
  end

  def chs_to_binary(str)
    str.unpack("C*").map { |i| i.to_s(2).rjust(8, '0') }.inject("") { |str, ch| str + ch }
  end

  #not used
  def hex_to_base_64_code()
    @str.unpack("C*")
  end

  def hex_to_binary(hex)
   hex.each_char.to_a.map{ |ch| to_binary(get_hex_index(ch), 4) }.inject(""){ |str, bits_4| str + bits_4 }
  end

  def hex_array_to_binary_array(arr)
    arr.map { |ch| int_to_binary(get_hex_index(ch), 4) }
  end

  def merg_strings(arr)
    arr.inject("") { |str, ch| str + ch }
  end

  def hex_to_binary(hex_string)
    # extract array of character values from hex string
    # find hex character index, map to 4-bit string and combine
    string_to_array(hex_string).map { |c| int_to_binary(get_hex_index(c)) }.inject("") { |str, ch| str + ch }
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
    arr.map { |s| s.to_i(2) }.map { |i| BASE_64_CHARACTERS[i] }.inject("") { |str, ch| str + ch }
  end

  def base_64_to_binary(base_64_str)
    return "" if base_64_str.blank?
    base_64_str.each_char.to_a.map { |ch| int_to_binary(get_base_64_index(ch), 6) }.inject("") { |str, six_bits| str = str + six_bits }
  end

  def binary_to_hex(bin_str)
    boolean_array_to_hex_string(bin_str.each_char.to_a.map { |ch| ch == "1" ? true : false})
  end

  def hex_to_boolean_array(hex_string)
    string_to_array(hex_to_binary(hex_string)).map { |b| b == "0" ? false : true }
  end

  def boolean_array_to_hex_string(boolean_arr)
    bin_str = boolean_arr.map { |b| b ? "1" : "0" }.inject("") { |str, ch| str + ch }

    # chunk into blocks of 4 and convert back to hex
    arr = []
    while (!bin_str.empty?)
      arr << bin_str.slice!(0..3)
    end

    arr.map { |bs| bs.to_i(2) }.map { |i| HEX_CHARACTERS[i] }.inject("") { |str, ch| str + ch }
  end

  def fixed_xor(hex_string_1, hex_string_2)
    raise "string must be the same length!" unless hex_string_1.size == hex_string_2.size

    boolean_arr_1 = hex_to_boolean_array(hex_string_1)
    boolean_arr_2 = hex_to_boolean_array(hex_string_2)

    boolean_arr_3 = []

    boolean_arr_1.zip(boolean_arr_2).each do |bit_1, bit_2|
      boolean_arr_3.push(bit_1 ^ bit_2)
    end

    boolean_array_to_hex_string(boolean_arr_3)
  end


  def encrypt_xor(key, string)
    hex_string_to_character_string(repeated_key_xor_to_hex(key, string))
  end

  def repeated_key_xor_to_hex(key, string)
    return "" if key.blank? || string.blank?
    #convert key into n-byte hex
    #convert string into hex
    #chunk string_hex into key-sized chunks
    # fixed_xor them and reconstitute into hex_string
    key_hex    = character_string_to_hex_string(key)
    string_hex = character_string_to_hex_string(string)
    chunk_size = key_hex.size

    #chunk into blocks of chunk_size
    arr = []
    while (!string_hex.empty?)
      arr << string_hex.slice!(0...chunk_size)
    end

    padding         = chunk_size - arr.last.size
    arr[arr.size-1] = arr[arr.size-1].ljust(chunk_size, "0") if padding > 0

    encoded = arr.map { |h| fixed_xor(key_hex, h) }.inject("") { |str, s| str = str + s }
    encoded[0...-padding] if padding > 0     # remove the padding chars
  end

  def decrypt_xor(char, hex_string)
    my_hex = hex_string.dup

    # chunk into bytes (2 hex characters)
    arr = []
    while (!my_hex.empty?)
      arr << my_hex.slice!(0..1)
    end

    char_in_hex = char.ord.to_s(16).rjust(2, "0") # get hex string of ascii character code
    hex_arr = arr.map { |h| fixed_xor(h, char_in_hex) } rescue [] # map fixed-xor with hex of char
    hex_array_to_character_string(hex_arr) # decoded the hex_array back into ascii
  end

  def find_key_to_xor_cipher(hex_string)
    max_percentage = 0
    winner         = 0.chr
    answer         = ""

    (0..255).each do |i|
      decoded = decrypt_xor(i.chr, hex_string)
      p       = percentage([" "], decoded) + percentage(VOWELS, decoded) + percentage(CONSONANTS, decoded) # compute % of vowels and characters
      if p > max_percentage # the highest percentage wins
        max_percentage = p
        winner         = i.chr
        answer         = decoded
      end
      #puts "#{i}: #{sprintf("%.2f\%", p * 100)} #{decoded}"
    end

    #puts "#{winner}: #{sprintf("%.2f\%", max_percentage * 100)} #{answer}" if max_percentage > 0.5

    [max_percentage, winner, answer]
  end

  def hex_array_to_character_string(hex_arr)
    hex_arr.map { |h| h.to_i(16).chr(Encoding::ASCII_8BIT) }.inject("") { |str, ch| str + ch } # decoded the hex_array back into ascii
  end

  def hex_string_to_character_string(hex_string)
    return "" if hex_string.blank?
    my_hex = hex_string.dup
    # chunk into 2-hex and xor with hex of char
    hex_arr = []
    while (!my_hex.empty?)
      hex_arr << my_hex.slice!(0..1)
    end
    hex_array_to_character_string(hex_arr)
  end

  def character_string_to_hex_string(string)
    string.each_char.to_a.map { |ch| ch.ord.to_s(16).rjust(2, '0') }.inject("") { |str, h| str = str + h }
  end

  def percentage(characters, string)
    string_length = string.size
    arr           = string_to_array(string)
    count         = 0
    arr.each do |ch|
      count += 1 if characters.include?(ch)
    end
    count.to_f / string_length.to_f
  end
end

#
# # str.unpack("C*").map{|i| i.to_s(2).rjust(8, '0')}.inject(""){|str, ch| str + ch}
# # hex_hash.map{|key, value| value.to_s(2).rjust(4, '0')}.inject(""){|str, ch| str + ch}
# # 65.chr => "A"
# # "A".ord => 65
# # character_value_array.map{|c| c.chr} => array with hex digits
# # character_value_array.map{|c| c.chr}.map{|hd| h_to_b(hd.to_i)}
