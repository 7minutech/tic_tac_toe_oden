require "pry-byebug"
# class that sets up a game of tic tac toe
class TicTacToe
  POSSIBLE_MOVES = [0, 2, 4].freeze
  BOARD_SPACES = (0..4).freeze
  SIMPLE_BOARD_SPACES = (0..2).freeze
  PLAYER_ONE_WIN = "xxx".freeze
  PLAYER_TWO_WIN = "ooo".freeze

  def initialize
    @board = Array.new(5) { Array.new(5) }
    # for only holding values and not displaying
    @simple_board = Array.new(3) { Array.new(3) }
    fill_board
    @current_move = " "
    @rounds_played = 0
    @player_turn = " "
    @move_combinations = ""
  end
  attr_reader :board, :current_move, :player_turn, :simple_board, :player_one_win,
              :player_two_win, :move_combinations, :game_over, :rounds_played

  private

  attr_writer :board, :current_move, :player_turn, :simple_board, :player_one_win,
              :player_two_win, :move_combinations, :game_over, :rounds_played

  def fill_board
    BOARD_SPACES.each do |i|
      BOARD_SPACES.each do |j|
        board[i][j] = if i.odd?
                        "-"
                      elsif j.odd?
                        "|"
                      else
                        " "
                      end
      end
    end
  end

  def display_board
    print "  1 2 3\n"

    board.each_with_index do |row, index|
      if index.even?
        print "#{(index / 2) + 1} #{row.join}\n"
      else
        print "  #{row.join}\n"
      end
    end
  end

  def player_move
    print "Enter your move in row,column format, like \"1,1\" for row 1 column 1 or q to quit \nMove:"
    self.current_move = gets.chomp
    return unless current_move == "q"

    abort "Exiting game..."
  end

  def valid_player_move
    player_move
    convert_move
    until valid_move?
      player_move
      convert_move
    end
  end

  def convert_move
    self.current_move = current_move.split(",").map!(&:to_i)
    # 1,2 is actaully 0,2
    current_move.map! { |move| (move - 1) * 2 }
  end

  def move_placed?
    if board[current_move[0]][current_move[1]] == " "
      false
    else
      puts "#{current_move} has already been placed"
      true
    end
  end

  def valid_move?
    if current_move.all? { |num| POSSIBLE_MOVES.include?(num) } && !move_placed?
      true
    else
      puts "Row and Column must be between [1,3]"
      false
    end
  end

  def add_row_moves
    simple_board.each { |row| self.move_combinations += "#{row.join}," }
  end

  def add_column_moves
    simple_board.transpose.each { |col| self.move_combinations += "#{col.join}," }
  end

  def add_diaganol_moves
    self.move_combinations += "#{(0..2).map { |i| simple_board[i][i] }.join},"
    self.move_combinations += "#{(0..2).map { |i| simple_board[i][2 - i] }.join},"
  end

  def add_move_combinations
    add_row_moves
    add_column_moves
    add_diaganol_moves
  end

  def clear_simple_board
    @simple_board.each { |row| row.fill(" ") }
  end

  def turn_selector
    @player_turn = rounds_played.even? ? "x" : "o"
  end

  def update_move_combinations
    simple_board[current_move[0] / 2][current_move[1] / 2] = @player_turn
    self.move_combinations = ""
    # need to add each row, column, and diagnol for checking
    add_move_combinations
  end

  def next_round
    self.rounds_played += 1
  end

  def place_move
    board[current_move[0]][current_move[1]] = @player_turn
  end

  def game_end_message
    if @player_turn == "x"
      puts "Player 1 wins!!!"
    elsif @player_turn == "o"
      puts "Player 2 wins!!!"
    else
      puts "Stalemate, no one could win"
    end
  end

  def play_round
    valid_player_move
    turn_selector
    place_move
    update_move_combinations
    next_round
    display_board
  end

  public

  def game_over?
    move_combinations.include?(PLAYER_ONE_WIN) || move_combinations.include?(PLAYER_TWO_WIN) || rounds_played >= 9
  end

  def play_again?
    print "Do you want to play agian? (y/n): "
    continue = gets.chomp.downcase
    if continue == "y"
      puts "Playing again..."
      true
    else
      puts "Exiting game..."
      false
    end
  end

  def reset
    fill_board
    clear_simple_board
    @current_move = " "
    @rounds_played = 0
    @player_turn = " "
    @move_combinations = " "
  end

  def play_game
    display_board
    play_round until game_over?
    game_end_message
    return unless play_again? == true

    reset
    play_game
  end
end
