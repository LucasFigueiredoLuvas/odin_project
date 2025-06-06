class SecretWord
    def initialize(file)
      @file = file
    end

    def generate
        tmpWordList = []
        file = File.open @file
        file.each_line {|line| tmpWordList << line }
        numberOfWords = tmpWordList.length
        result = ''
      
        while true
            word = tmpWordList[rand(numberOfWords)]
            if word.length > 5 && word.length < 12
                result = word
                break
            end
        end

      result.chomp
    end
end