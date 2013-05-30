class AddZipCodeMapToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :zip_code_map_id, :integer
  end
end
