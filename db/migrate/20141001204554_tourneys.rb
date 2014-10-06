class Tourneys < ActiveRecord::Migration
  def change
    create_table :tourneys do |col|
      # has tourney.id
      col.belongs_to :winner
    end  
  end
end

