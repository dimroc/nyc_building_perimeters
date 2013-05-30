class AddWorldIdIndexOnRegions < ActiveRecord::Migration
  def change
    add_index :regions, :world_id
  end
end
