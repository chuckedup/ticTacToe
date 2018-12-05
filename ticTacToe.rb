class Game
    def initialize 
        @x_player = Player.new("X")
        @o_player = Player.new ("O")
        @board = Board.new
        
        @current_player = @x_player
        @game_state = true
        display_rules
        moves
    end

    def display_rules
        puts "Get three pieces in a row, horizontally, vertically or diagonally, to win. "
        puts "The postions are labelled alpha-numerically as such: "
        ('a'..'c').each do |letter|
          (1..3).each do |num|
            print "#{letter}#{num} "
          end
          puts
        end
    end

    def moves
        tie_counter = 0
        while @game_state
            puts "What is your move #{@current_player.player}?"
            @player_move = gets.chomp.downcase
            move_validity_check 
            @board.show
            tie_counter += 1
            win if @board.check(@player_move.to_sym)
            tie if tie_counter == 9 && !@board.check(@player_move.to_sym)
            @current_player == @o_player ? @current_player = @x_player : @current_player = @o_player 
        end
        restart
    end

    def move_validity_check
        while !@board.change(@player_move.to_sym, @current_player.player) do
            puts "That is not a valid move."
            puts "What is your move #{@current_player.player}?"
            @player_move = gets.chomp
            @board.change(@player_move, @current_player.player)
        end
    end

    def win
        puts "#{@current_player.player} has won!"
        @game_state = false
    end

    def tie
        puts "Tie Game!"
        @game_state = false
    end

    def restart
        puts "Would you like to start a new game? (Y/N)"
        choice = gets.chomp.downcase
        choice == "y" ? Game.new : "Thanks for Playing!"
    end
end

class Player
    attr_accessor :player 
    def initialize (player)
        @player = player
    end
end

class Board
    attr_accessor :board
    def initialize
        @board = {a1:"|_|",a2:"|_|",a3:"|_|",
                  b1:"|_|",b2:"|_|",b3:"|_|",
                  c1:"|_|",c2:"|_|",c3:"|_|"}
    end

    def change position, turn
        if @board[position] == nil
            return false
        elsif @board[position] == "|X|" || @board[position] == "|O|" 
            return false
        else 
            @board[position] = "|#{turn}|"
        end
    end

    def show
        num_columns = 0
        @board.each_value do |value|
            print value
            num_columns+=1
            puts if num_columns%3==0
        end
    end

    def check(player_move)
        #Cases for each move are used to minimize the amount of checks performed.  Instead of checking all eight win cases each time,
        #four win cases are checked for the center move, three for the corners, and two for the edges.
        case player_move
        when :a1
            return true if @board[player_move]==@board[:a2] && @board[player_move]==@board[:a3] || @board[player_move]==@board[:b1] && @board[player_move]==@board[:c1] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:c3]
        when :a3
            return true if @board[player_move]==@board[:a1] && @board[player_move]==@board[:a2] || @board[player_move]==@board[:b3] && @board[player_move]==@board[:c3] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:c1]
        when :c1
            return true if @board[player_move]==@board[:c2] && @board[player_move]==@board[:c3] || @board[player_move]==@board[:b1] && @board[player_move]==@board[:a1] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:a3]
        when :c3
            return true if @board[player_move]==@board[:c1] && @board[player_move]==@board[:c3] || @board[player_move]==@board[:b3] && @board[player_move]==@board[:a3] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:a1]
        when :b2
            return true if @board[player_move]==@board[:b1] && @board[player_move]==@board[:b3] || @board[player_move]==@board[:a2] && @board[player_move]==@board[:c2] || @board[player_move]==@board[:a1] && @board[player_move]==@board[:c3] || @board[player_move]==@board[:a3] && @board[player_move]==@board[:c1]
        when :a2
            return true if @board[player_move]==@board[:a1] && @board[player_move]==@board[:a3] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:c2]
        when :b1
            return true if @board[player_move]==@board[:b2] && @board[player_move]==@board[:b3] || @board[player_move]==@board[:a1] && @board[player_move]==@board[:c1]
        when :b3
            return true if @board[player_move]==@board[:b1] && @board[player_move]==@board[:b2] || @board[player_move]==@board[:a3] && @board[player_move]==@board[:c3]
        when :c2
            return true if @board[player_move]==@board[:c1] && @board[player_move]==@board[:c3] || @board[player_move]==@board[:b2] && @board[player_move]==@board[:a2]
        end
    end

end

game = Game.new
