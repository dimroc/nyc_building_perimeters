class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :region_id
      t.integer :left
      t.integer :top

      t.timestamps
    end
  end
end
