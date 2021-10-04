class CreateProjectTechnology < ActiveRecord::Migration[6.0]
  def change
    create_table :project_technologies do |t|
      t.references :project, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true

      t.timestamps
    end
    add_index :project_technologies, %i[project_id technology_id], unique: true
  end
end
