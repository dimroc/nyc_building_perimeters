class AddThreeJsToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :threejs, :text
  end
end
