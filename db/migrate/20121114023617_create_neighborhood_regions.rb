class CreateNeighborhoodRegions < ActiveRecord::Migration
  def change
    create_table :neighborhood_regions do |t|
      t.integer :region_id
      t.integer :neighborhood_id
    end
  end
end
