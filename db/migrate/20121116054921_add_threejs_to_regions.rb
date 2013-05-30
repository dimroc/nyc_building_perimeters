class AddThreejsToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :threejs, :text
  end
end
