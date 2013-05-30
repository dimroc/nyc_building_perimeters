class AddDirectionToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :direction, :float
  end
end
