class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
