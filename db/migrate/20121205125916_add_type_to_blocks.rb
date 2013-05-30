class AddTypeToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :type, :string

    execute(<<-SQL)
      UPDATE blocks SET type = 'Block::Video';
    SQL

    add_index :blocks, :type
    add_index :blocks, :panda_video_id
  end
end
