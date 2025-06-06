# frozen_string_literal: true

def stock_picker(prices_list)
  best_profit = 0
  best_days = ''

  prices_list.each_with_index do |item_a, i|
    prices_list.each_with_index do |item_b, j|
      current_profit = item_b - item_a

      if current_profit > best_profit && i < j
        best_profit = current_profit
        best_days = [i, j]
      end
    end
  end
end

stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
