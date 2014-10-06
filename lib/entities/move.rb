module RPS
  class Move < ActiveRecord::Base
    belongs_to :game
    belongs_to :player
  end
end