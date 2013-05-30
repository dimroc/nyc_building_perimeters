class AddNeighborhoodToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :neighborhood_id, :integer
  end
end
