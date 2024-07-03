# class that sets up a game of tic tac toe
class TicTacToe
  attr_accessor :board, :current_move, :x_o, :simple_board, :player_one_win, :player_two_win

  POSSIBLE_MOVES = (1..3).freeze
  WINNING_COMBINAITONS = (0..7).freeze
  BOARD_SPACES = (0..4).freeze
  PLAYER_ONE_WIN = "xxx"
  PLAYER_TWO_WIN = "ooo"

  def initialize
    @board = Array.new(5) { Array.new(5) }
    @current_move = "1:1"
    @rounds_played = 0
    @x_o = "x"
    @simple_board = Array.new(3) {Array.new(3)}
    @player_one_win = false
    @player_two_win = false
  end

  def fill_board
    BOARD_SPACES.each do |i|
      BOARD_SPACES.each do |j|
        board[i][j] = "|" if j.odd?
        board[i][j] = "-" if i.odd?
        board[i][j] = "x" if i.even? && j.even?
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
      return false unless POSSIBLE_MOVES.include?(num)
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
    row -= 1
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

  # 00 01 02
  # 10 11 12
  # 20 21 23 
  def winner?
    row_arr = []
    col_arr = []
    simple_board.each do |row|
      row_arr = row
      row.each do |col|
        col_arr.push(col)
      end
      col_str = col_arr.reduce {|result,space| result + space}
      row_str = row_arr.reduce {|result,space| result + space}
      self.player_one_win = true if col_str == PLAYER_ONE_WIN || row_str == PLAYER_ONE_WIN
      self.player_one_win = true if col_str == PLAYER_TWO_WIN || row_str == PLAYER_TWO_WIN
      col_arr.clear
    end
    puts player_one_win
    puts player_two_win
  end

  def play_game
  end
end
game1 = TicTacToe.new
game1.fill_board
game1.display_board
game1.map_simple_board
game1.winner?
