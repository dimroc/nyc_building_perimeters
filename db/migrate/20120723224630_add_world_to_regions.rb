class AddWorldToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :world_id, :integer
  end
end
