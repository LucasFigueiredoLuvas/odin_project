# frozen_string_literal: true

class BubbleSort
  # Receives an Array of integers and returns that 
  # Array with the values ​​sorted.
  def start(list = [])
    unsorted = true
    while unsorted
      i = 0
      unsorted = false
      while i < (list.length - 1)
        if list[i] > list[i + 1]
          list[i], list[i + 1] = list[i + 1], list[i]
          unsorted = true
        end
        i += 1
      end
    end

    return list
  end
end
