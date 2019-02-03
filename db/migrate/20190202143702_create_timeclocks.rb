class CreateTimeclocks < ActiveRecord::Migration[5.1]
  def change
    create_table :timeclocks do |t|
      t.string :device_id
      t.string :epoch_time, array: true

      t.timestamps
    end
    add_index :timeclocks, :epoch_time, using: 'gin'
  end
end
