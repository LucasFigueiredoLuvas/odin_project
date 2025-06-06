# frozen_string_literal: true


class SubString
  def initialize(input_text, list = [])
    @input = input_text
    @dictionary = list
  end
  
  def start
    output = Hash.new(0)

    return 'none' if @input.length == 0 || @dictionary.length == 0
    
    @dictionary.each do |dic_text|
      verified = @input.scan(dic_text.downcase)
      output[dic_text] = verified.length if verified.length.positive?
    end

    return output
  end
end