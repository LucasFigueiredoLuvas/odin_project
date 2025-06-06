require_relative 'secret_word'

class Game
    def initialize(file_path)
        @secret_word = SecretWord.new file_path
        main_menu
    end

    private

    def main_menu
      system('clear')
      puts <<-DOC
    _____________
    |           |  Iniciar Novo Jogo [1]
    |  JOGO DA  |  Carregar Jogo     [2]
    | F O R C A |  Sair              [3]
    |___________|
                DOC
        filter_menu_option gets.chomp        
    end

    def filter_menu_option(option)
        case option
        when '1'
            word = new_game
            game_loop word
        when '2'
            puts load
        when '3'
            system('exit')
        else
            puts '-- OPÇÃO INVÁLIDA -- Reiniciando...'
            sleep(2)
            main_menu
        end
    end

    def new_game
        return @secret_word.generate
    end

    def verify_attempt(word, letter)
        indexes = []
        (0...word.length).each do |i|
            indexes << i if word[i] == letter
        end
        return indexes
    end

    def game_loop(word, placeholder = [], attempts = 7)
        saved = false
        word.length.times {|time| placeholder << ' _ '}
        while attempts > 0
            display_in_game(saved, word.length, attempts, placeholder, word)
            letter = gets.chomp
            saved = false
            result = verify_attempt word, letter

            if letter == '-sv'
              saved = save(word, placeholder, attempts)
              attempts += 1
            end
            
            attempts -= 1 if result == []
            result.each {|i| placeholder[i] = " #{letter} " }
            
            win_game(word) if !placeholder.include?(' _ ')
        end

        lose_game if attempts == 0
    end

    def save(word, placeholder, attempts)
        file = File.new('./save_game.txt', 'w')
        file.write('*', word, '*', placeholder, '*', attempts)
        file.close
        return true
    end

    def load
        file_data = File.open('./save_game.txt', 'r')
        save = file_data.readline.split '*'
        file_data.close
        return save 
    end

    def display_in_game(saved, word_len, attempts, placeholder, word)
      system('clear')
            puts <<-DOC

Progresso (digite: -sv)     -> #{saved ? "Salvo" : "Não salvo"}
Número de letras na palavra -> #{word_len}
Tentativas:                 -> | #{attempts} |
Palavra:                    -> #{placeholder.join} - #{word}
Digite seu palpite:
                    DOC
    end

    def lose_game
        puts "Você perdeu! Fim de Jogo!"
        puts "-- REININCIANDO EM 5 SEGUNDOS --"
        sleep(5)
        main_menu
    end

    def win_game(word)
        puts "!!! Você ganhou !!!\n A palavra é: #{word}"
        puts "-- RETORNANDO AO MENU EM 5 SEGUNDOS --"
        sleep(5)
        main_menu
    end
end