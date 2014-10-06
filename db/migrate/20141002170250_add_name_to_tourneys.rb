class AddNameToTourneys < ActiveRecord::Migration
  def change
    add_column :tourneys, :name, :string
  end
end
