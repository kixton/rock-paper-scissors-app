class RemoveColumnsFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :player1_id
    remove_column :games, :player2_id
    remove_column :games, :p1move
    remove_column :games, :p2move
  end
end
