module RPS
  class Player < ActiveRecord::Base
    has_many :moves
    has_many :games, through: :moves
    validates :name, presence: true
  end
end