class CreateAffiliations < ActiveRecord::Migration[6.1]
  def change
    create_table :affiliations do |t|
      t.string :name
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
    add_index :affiliations, :name
  end
end
