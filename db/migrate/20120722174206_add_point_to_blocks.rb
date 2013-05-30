class AddPointToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :point, :point, srid: 3785
    add_index :blocks, :point, spatial: true
  end
end
