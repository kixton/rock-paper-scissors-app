class Moves < ActiveRecord::Migration
  def change
    create_table :moves do |col|      
      col.belongs_to :game 
      col.belongs_to :player
      col.string :move
    end  
  end
end
