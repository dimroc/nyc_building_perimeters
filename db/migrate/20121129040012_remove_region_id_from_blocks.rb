class RemoveRegionIdFromBlocks < ActiveRecord::Migration
  def up
    remove_column :blocks, :region_id
  end

  def down
    add_column :blocks, :region_id, :integer
  end
end
