class ChangeTopToBottomOnBlocks < ActiveRecord::Migration
  def change
    rename_column :blocks, :top, :bottom
  end
end
