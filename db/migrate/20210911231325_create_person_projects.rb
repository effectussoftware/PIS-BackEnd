class CreatePersonProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :person_projects do |t|
      t.integer :person_id, null: false
      t.integer :project_id, null: false
      t.string :rol

      t.timestamps
    end
    add_index :person_projects, [:person_id, :project_id], unique: true
  end
end
