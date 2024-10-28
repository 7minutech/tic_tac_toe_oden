require_relative "../lib/tic_tac_toe_game"
require "pry-byebug"
describe TicTacToe do
  before do
    allow($stdout).to receive(:write) # Suppresses all console output
  end
  let(:game) { described_class.new }
  describe "#game_over" do
    it "returns true if player 1 has a winning combination" do
      allow(game).to receive(:gets).and_return("1,1", "2,1", "2,2", "3,1", "3,3")
      game.play_game
      player_1_win = game.send(:game_over?)
      expect(player_1_win).to eq(true)
    end
    it "returns true if player 2 has a winning combination" do
      allow(game).to receive(:gets).and_return("2,3", "1,1", "2,2", "2,1", "3,3", "3,1")
      game.play_game
      player_2_win = game.send(:game_over?)
      expect(player_2_win).to eq(true)
    end
    it "returns true if no one wins by the 9th round" do
      tie_moves = %w[1 2 3]
      tie_moves = tie_moves.repeated_permutation(2).to_a.map! { |move| move.join(",") }
      tie_moves.push(tie_moves[0])
      tie_moves.shift
      allow(game).to receive(:gets).and_return(*tie_moves)
      game.play_game
      tie_game = game.send(:game_over?)
      expect(tie_game).to eq(true)
    end
    it "returns false when no one has won yet" do
      allow(game).to receive(:gets).and_return("2,1", "3,2", "1,2")
      3.times { game.send(:play_round) }
      active_game = game.send(:game_over?)
      expect(active_game).to eq(false)
    end
  end
  describe "#play_game" do
    before do
      allow(game).to receive(:gets).and_return("1,1", "2,1", "2,2", "3,1", "3,3", "n")
    end
    it "plays rounds until the game is over" do
      exiting_message = "Exiting game..."
      winner_message = "Player 1 wins!!!"

      expect(game).to receive(:puts).with(winner_message)
      expect(game).to receive(:puts).with(exiting_message)
      game.play_game
    end
  end

  describe "#reset" do
    before do
      allow(game).to receive(:gets).and_return("1,1", "2,1", "2,2")
      3.times { game.send(:play_round) }
    end
    it "returns that state of the object back to initilization" do
      game.send(:reset)
      expect(game.rounds_played).to eq(0)
    end
  end

  describe "valid_player_move" do
    before do
      invalid_input = "f"
      valid_input = "2,2"
      allow(game).to receive(:gets).and_return(invalid_input, valid_input)
    end
    it "stops once a valid move is given" do
      error_message = "Row and Column must be between [1,3]"
      game.send(:play_round)
      allow(game).to receive(:puts).with(error_message).once
    end
  end
end
