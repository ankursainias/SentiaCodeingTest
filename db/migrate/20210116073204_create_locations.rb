class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
    add_index :locations, :name
  end
end
