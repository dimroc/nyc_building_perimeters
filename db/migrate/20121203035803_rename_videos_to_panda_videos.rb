class RenameVideosToPandaVideos < ActiveRecord::Migration
  def change
    rename_table :videos, :panda_videos
  end
end
