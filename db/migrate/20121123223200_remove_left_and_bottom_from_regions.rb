class RemoveLeftAndBottomFromRegions < ActiveRecord::Migration
  def change
    remove_column :regions, :left
    remove_column :regions, :bottom
  end
end
