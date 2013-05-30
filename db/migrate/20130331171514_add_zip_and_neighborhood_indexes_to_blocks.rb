class AddZipAndNeighborhoodIndexesToBlocks < ActiveRecord::Migration
  def change
    add_index(:blocks, :zip_code_map_id)
    add_index(:blocks, :neighborhood_id)
  end
end
