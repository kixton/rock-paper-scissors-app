class Games < ActiveRecord::Migration
  def change
    create_table :games do |col|
      # has game.id
      
      col.belongs_to :tourney 
      col.integer :round

      col.belongs_to :player1
      col.belongs_to :player2

      col.string :p1move
      col.string :p2move

      col.belongs_to :winner
    end  
  end
end

# id  tourney  round  p1  p2  move1  move2  winner
# 1      1       1    a   e     r      s      a
# 2      1       1    b   f     r      s      b
# 3      1       1    c   g     r      s      c
# 4      1       1    d   h     r      s      d

# 5      1       2    a   b     r      s      a
# 6      1       2    c   d     r      s      c

# 7      1       3    a   c     r      s      a
# ----------------------------------------------
# 8      2       1    a   b     r      s      a
# 9      2       1    c   d     r      s      c

# 10     2       2    a   c     r      s      a
