class Display
	def main pieces, current_player, message
		board_display =  "______________________________\n"
		board_display += "________JOGO DA VELHA_________\n"
		board_display += "|                            |\n"
		board_display += "|   [a]   #{pieces[0]} | #{pieces[1]} | #{pieces[2]}          |\n"
		board_display += "|        ___|___|___         |\n"
		board_display += "|   [b]   #{pieces[3]} | #{pieces[4]} | #{pieces[5]}          |\n"
		board_display += "|        ___|___|___         |\n"
		board_display += "|   [c]   #{pieces[6]} | #{pieces[7]} | #{pieces[8]}          |\n"
		board_display += "|           |   |            |\n"
		board_display += "|                            |\n"
		board_display += "|        [1] [2] [3]         |\n"
		board_display += "|____________________________|\n\n"
		board_display += "|  => JOGADOR DA VEZ: [ 0#{current_player.id}/#{current_player.symb} ]\n|\n"
		board_display += "|  => STATUS: [ #{message} ]\n"
		print board_display
	end
end
