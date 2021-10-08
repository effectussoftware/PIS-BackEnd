class CreatePersonTechnologies < ActiveRecord::Migration[6.0]
  def change
    create_table :person_technologies do |t|
      t.references :person, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true
      t.string :seniority, null: false

      t.timestamps
    end
    add_index :person_technologies, %i[person_id technology_id], unique: true
  end
end
