module RPS
  class Game < ActiveRecord::Base
    belongs_to :tourney
    has_many :moves
    has_many :players, through: :moves

    def opponent(player)
      if player == players[0]
        players[1]
      elsif player == players[1]
        players[0]
      end
    end

    def winner
      Player.find(self.winner_id)
    end

    def play(move, opponent_move)
      RockPapeScis.play(player_1: {id: move.player.id, move: move.move}, player_2: {id: opponent_move.player.id, move: opponent_move.move})
    end

    def clear_moves
      self.moves[0].move = nil
      self.moves[1].move = nil
      self.moves[0].save
      self.moves[1].save
    end

    # split the array into arrays of two
  end
end