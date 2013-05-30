class AddVideoIdToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :video_id, :integer
  end
end
