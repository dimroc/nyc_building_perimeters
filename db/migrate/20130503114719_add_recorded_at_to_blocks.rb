class AddRecordedAtToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :recorded_at, :timestamp
    execute("UPDATE blocks SET recorded_at = current_timestamp");
    change_column :blocks, :recorded_at, :timestamp, null: false
  end
end
