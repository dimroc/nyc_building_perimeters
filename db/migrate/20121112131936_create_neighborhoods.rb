class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name, null: false
      t.string :borough, null: false
      t.point :point, srid: 3785 # null: false does not work for geo

      t.timestamps
    end
  end
end
