class AddLeftAndBottomToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :left, :integer, default: 0, null: false
    add_column :regions, :bottom, :integer, default: 0, null: false
  end
end
