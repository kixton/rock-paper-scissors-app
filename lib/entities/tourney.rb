module RPS
  class Tourney < ActiveRecord::Base
    belongs_to :winner, class_name: "Player"
    has_many :games
  end
end