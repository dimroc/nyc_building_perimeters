class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :panda_id
      t.string :encoding_id
      t.string :original_filename
      t.integer :width
      t.integer :height
      t.integer :duration
      t.string :screenshot
      t.string :url

      t.timestamps
    end
  end
end
