class NewTieColumnForGames < ActiveRecord::Migration
  def change
    add_column :games, :tie, :boolean
  end
end
