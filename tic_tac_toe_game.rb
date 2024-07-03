# class that sets up a game of tic tac toe
class TicTacToe
  attr_accessor :board, :current_move, :x_o, :simple_board, :player_one_win,
                :player_two_win, :move_combinaitons, :game_over, :rounds_played

  POSSIBLE_MOVES = (1..3).freeze
  WINNING_COMBINAITONS = (0..7).freeze
  BOARD_SPACES = (0..4).freeze
  SIMPLE_BOARD_SPACES = (0..2).freeze
  PLAYER_ONE_WIN = "xxx".freeze
  PLAYER_TWO_WIN = "ooo".freeze

  def initialize
    @board = Array.new(5) { Array.new(5) }
    @current_move = " "
    @rounds_played = 0
    @x_o = " "
    @simple_board = Array.new(3) { Array.new(3) }
    @player_one_win = false
    @player_two_win = false
    @move_combinaitons = ""
    @game_over = false
  end

  def fill_board
    BOARD_SPACES.each do |i|
      BOARD_SPACES.each do |j|
        board[i][j] = "|" if j.odd?
        board[i][j] = "-" if i.odd?
        board[i][j] = " " if i.even? && j.even?
      end
    end
  end

  def display_board
    board.each do |row|
      row.each do |col|
        print col
      end
      print "\n"
    end
  end

  def player_move
    print "Enter your move in row:column formate, like \"1:1\" for row 1 column 1"
    print "\nMove: "
    self.current_move = gets.chomp
  end

  def convert_move
    move_arr = current_move.split(":")
    move_arr.map!(&:to_i)
    self.current_move = move_arr
  end

  def valid_move?
    current_move.each do |num|
      unless POSSIBLE_MOVES.include?(num)
        puts "Row and Column must be between [1,3]"
        return false
      end
    end
    true
  end

  def x_o_selector
    self.x_o = if rounds_played.even?
                 "x"
               else
                 "o"
               end
  end

  def map_move
    row = current_move[0]
    col = current_move[1]
    row = (row - 1) * 2
    col = (col - 1) * 2
    current_move[0] = row
    current_move[1] = col
  end

  def place_move
    board[current_move[0]][current_move[1]] = @x_o
  end

  def map_simple_board
    (0..2).each do |i|
      (0..2).each do |j|
        simple_board[i][j] = board[i * 2][j * 2]
      end
    end
  end

  def row_column_moves
    simple_board.each do |row|
      self.move_combinaitons += "#{row.reduce { |result, space| result + space }},"
    end
    simple_board.transpose.each do |col|
      self.move_combinaitons += "#{col.reduce { |result, space| result + space }},"
    end
  end

  def diaganol_moves
    SIMPLE_BOARD_SPACES.each do |i|
      self.move_combinaitons += simple_board[i][i]
    end
    self.move_combinaitons += ","
    counter = 2
    SIMPLE_BOARD_SPACES.each do |i|
      self.move_combinaitons += simple_board[i][counter]
      counter -= 1
    end
    self.move_combinaitons += ","

  end

  def update_move_combinations
    map_simple_board
    self.move_combinaitons = ""
    row_column_moves
    diaganol_moves
  end

  def pick_x_o
    x_o_selector
    next_round
  end

  def winner?
    if move_combinaitons.include?(PLAYER_ONE_WIN)
      puts "Player one wins!"
      self.player_one_win = true
    elsif move_combinaitons.include?(PLAYER_TWO_WIN)
      puts "Player two wins!"
      self.player_two_win = true
    else
      false
    end
  end

  def next_round
    self.rounds_played += 1
  end

  def play_game
    fill_board
    display_board
    until game_over == true
      player_move
      convert_move
      next unless valid_move?

      map_move
      pick_x_o
      place_move
      display_board
      update_move_combinations
      self.game_over = true if winner?
    end
  end
end
game1 = TicTacToe.new
game1.play_game

# need to check if a that move has been played
