class AddIndexToPandaVideosPandaId < ActiveRecord::Migration
  def change
    add_index :panda_videos, :panda_id, unique: true
  end
end
