class AddGeometryToNeighborhoods < ActiveRecord::Migration
  def change
    remove_column :neighborhoods, :point
    add_column :neighborhoods, :geometry, :geometry, srid: 3785
  end
end
