# class that sets up a game of tic tac toe
class TicTacToe
  attr_accessor :board, :current_move

  POSSIBLE_MOVES = (1..3).freeze
  def initialize
    @board = Array.new(5) { Array.new(5) }
    @current_move = "1:1"
    @rounds_played = 0
    @x_o = "x"
  end

  def fill_board
    (0...board.length).each do |i|
      (0...board.length).each do |j|
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

  def get_player_move
    print "Enter your move in row:column formate, like \"1:1\" for row 1 column 1"
    print "\nMove: "
    self.current_move = gets.chomp
  end

  def valid_move?
    move_arr = current_move.split(":")
    move_arr.map!(&:to_i)
    move_arr.each do |num|
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
    p current_move
    move_arr = current_move.split(":")
    p move_arr
    move_arr.map!(&:to_i)
    p move_arr
    row = move_arr[0]
    col = move_arr[1]
    row -= 1
    col = (col - 1) * 2
    move_arr[0] = row
    move_arr[1] = col
    self.current_move = move_arr
  end

  def place_move

  end

  def winner?
  end

  def play_game
  end
end
game1 = TicTacToe.new
game1.fill_board
game1.display_board
game1.get_player_move
game1.valid_move?
game1.map_move
game1.place_move
game1.display_board

