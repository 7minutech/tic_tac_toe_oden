# class that sets up a game of tic tac toe
class TicTacToe
  attr_accessor :board, :current_move

  def initialize
    @board = Array.new(5) { Array.new(5) }
    @current_move = ""
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
  end

  def place_move(move)
  end

  def winner?
  end

  def play_game
  end
end
game1 = TicTacToe.new
game1.fill_board
game1.display_board
