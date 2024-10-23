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
    fill_board
    @current_move = " "
    @rounds_played = 0
    @player_turn = " "
    # mapped board that is just the x's and o's
    # easier to check for winner b/c of conversion to str from arr
    @simple_board = Array.new(3) { Array.new(3) }
    @player_one_win = false
    @player_two_win = false
    @move_combinaitons = ""
    @game_over = false
  end

  private

  attr_accessor :board, :current_move, :player_turn, :simple_board, :player_one_win,
                :player_two_win, :move_combinaitons, :game_over, :rounds_played

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
    board.each { |row| puts row.join }
  end

  def player_move
    print "Enter your move in row:column formate, like \"1:1\" for row 1 column 1\nMove:"
    self.current_move = gets.chomp
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
    self.current_move = current_move.split(":").map!(&:to_i)
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
    # binding.pry
    if current_move.all? { |num| POSSIBLE_MOVES.include?(num) } && !move_placed?
      true
    else
      puts "Row and Column must be between [1,3]"
      false
    end
  end

  def turn_selector
    @player_turn = rounds_played.even? ? "x" : "o"
  end

  def place_move
    board[current_move[0]][current_move[1]] = @player_turn
  end

  def map_simple_board
    SIMPLE_BOARD_SPACES.each do |i|
      SIMPLE_BOARD_SPACES.each do |j|
        simple_board[i][j] = board[i * 2][j * 2]
      end
    end
  end

  def row_column_moves
    simple_board.each { |row| self.move_combinaitons += "#{row.join}," }
    simple_board.transpose.each { |col| self.move_combinaitons += "#{col.join}," }
  end

  def diaganol_moves
    self.move_combinaitons += "#{(0..2).map { |i| simple_board[i][i] }.join},"
    self.move_combinaitons += "#{(0..2).map { |i| simple_board[i][2 - i] }.join},"
  end

  def update_move_combinations
    map_simple_board
    self.move_combinaitons = ""
    row_column_moves
    diaganol_moves
  end

  def winner?
    if move_combinaitons.include?(PLAYER_ONE_WIN)
      puts "Player one wins!"
      self.player_one_win = true
      true
    elsif move_combinaitons.include?(PLAYER_TWO_WIN)
      puts "Player two wins!"
      self.player_two_win = true
      true
    elsif rounds_played >= 9
      puts "It's a tie!"
      true
    else
      false
    end
  end

  def next_round
    self.rounds_played += 1
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
    self.game_over = false
    self.rounds_played = 0
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

  def play_game
    display_board
    until game_over == true
      play_round
      self.game_over = true if winner?
      p move_combinaitons
    end
    return unless play_again? == true

    reset
    play_game
  end
end
tic_tac_toe_game = TicTacToe.new
tic_tac_toe_game.play_game
