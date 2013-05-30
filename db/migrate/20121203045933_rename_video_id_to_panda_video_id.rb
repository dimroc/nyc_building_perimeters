class RenameVideoIdToPandaVideoId < ActiveRecord::Migration
  def change
    rename_column :blocks, :video_id, :panda_video_id
  end
end
