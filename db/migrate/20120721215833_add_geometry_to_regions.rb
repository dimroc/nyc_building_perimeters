class AddGeometryToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :geometry, :geometry, srid: 3785
    add_index :regions, :geometry, spatial: true
  end
end
