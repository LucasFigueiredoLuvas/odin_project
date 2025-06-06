# frozen_string_literal: true

dictionary = %w[ass come shit wow hey what man goes on]

def substrings(input_text, list)
  output = Hash.new(0)

  list.each do |dic_text|
    verified = input_text.scan(dic_text.downcase)
    output[dic_text] = verified.length if verified.length.positive?
  end

  output
end

puts substrings('Lucas e Lucas onwowwow', dictionary)
