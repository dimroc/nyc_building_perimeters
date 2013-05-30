class DropNeighborhoodRegions < ActiveRecord::Migration
  def change
    drop_table :neighborhood_regions
  end
end
