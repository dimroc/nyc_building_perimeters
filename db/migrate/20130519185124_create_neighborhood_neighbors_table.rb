class CreateNeighborhoodNeighborsTable < ActiveRecord::Migration
  def change
    create_table :neighborhood_neighbors, :id => false do |t|
      t.integer :neighborhood_id
      t.integer :neighbor_id
    end

    add_index :neighborhood_neighbors, :neighborhood_id
    add_index :neighborhood_neighbors, [:neighborhood_id, :neighbor_id], unique: true
  end
end
