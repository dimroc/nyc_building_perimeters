class AddBoundingBoxesToWorld < ActiveRecord::Migration
  def change
    add_column :worlds, :mercator_bounding_box_geometry, :geometry, srid: 3785
    add_column :worlds, :mesh_bounding_box_geometry, :geometry
  end
end
