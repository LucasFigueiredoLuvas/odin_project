require_relative 'display'
require_relative 'player'

class Game
	attr_reader :board

	WINNER_POSITIONS = [
		[0, 1, 2],
		[3, 4, 5],
		[6, 7, 8],
		[0, 3, 6],
		[1, 4, 7],
		[2, 5, 8],
		[0, 4, 8],
		[2, 4, 6]
	].freeze

	def initialize
		@board = Array.new(9, '.')
		@options = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3']
		@display = Display.new
		@available_positions = []
		@player01 = Player.new 1
		@player02 = Player.new 2
		@current_player
	end

	def run
		define_players
		@current_player = @player01
		status_code = -1

		loop do
			if winner?
				status_code = 1
			end
			system('clear')
			@display.main(@board, @current_player, messages(status_code))

			choice = gets.chomp

			break if status_code == 1
			break if choice == 'sair'
			
			status_code = verify_choice choice
		end
	end

	def verify_choice choice
		result = @options.index do |value|
			value == choice
		end

		if result == nil
			return 0
		else
			return verify_board result
		end
	end

	def verify_board index
		if @board[index] == '.'
			@board[index] = @current_player.symb
			change_turn
			return 2
		elsif !tie?
			return 3
		else
			return 4
		end
	end

	def define_players
		symb = ['x', 'o'].shuffle
		@player01.symb = symb[0]
		@player02.symb = symb[1]
	end

	def change_turn
		if @current_player.id == @player01.id
			@current_player = @player02
		else
			@current_player = @player01
		end
	end

	def winner?
    WINNER_POSITIONS.any? do |patter|
      patter.all? { |position| @board[position] == @current_player.symb }
    end
  end
	
	def tie?
		@board.any? {|position| position == '.'}
	end

	def messages status
		message = ""
		if status < 0
			message = "COMEÇAR"
		elsif status == 0
			message = "Jogada Inválida"
		elsif status == 1
			message = "JOGADOR 0#{@current_player.id} VENCEU"
		elsif status == 2
			message = "Faça sua Jogada"
		elsif status == 3
			message = "Empate"
		else
			message = "Posição Ocupada"
		end
		return message
	end
end


