class AddUserToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :user_id, :integer
  end
end
