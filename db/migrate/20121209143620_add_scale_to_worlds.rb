class AddScaleToWorlds < ActiveRecord::Migration
  def change
    add_column :worlds, :mesh_scale, :float
  end
end
