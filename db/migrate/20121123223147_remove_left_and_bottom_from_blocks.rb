class RemoveLeftAndBottomFromBlocks < ActiveRecord::Migration
  def change
    remove_column :blocks, :left
    remove_column :blocks, :bottom
  end
end
