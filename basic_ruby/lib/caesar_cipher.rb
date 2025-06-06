# frozen_string_literal: true

# CaesarCipher create an cipher with an message.
class CaesarCipher
  def initialize(message, shift)
    @message = message
    @shift = shift
  end

  def cipher
    result = ''
    @message.each_char do |char|
      char_base = char.ord < 91 ? 65 : 97
      if char.ord.between?(65, 90) || char.ord.between?(97, 122)
        rotation = (((char.ord - char_base) + @shift) % 26) + char_base
        result += rotation.chr
      else
        result += char
      end
    end

    return result
  end
end
