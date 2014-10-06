class Players < ActiveRecord::Migration
  def change
    create_table :players do |col|
      col.string :name
      col.string :phone
      col.string :email
      col.string :password
      col.integer :wins
      col.integer :losses
    end  
  end
end
