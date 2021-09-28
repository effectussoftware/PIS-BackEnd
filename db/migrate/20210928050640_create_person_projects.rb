class CreatePersonProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :person_projects do |t|
      t.belongs_to :person, null: false, foreign_key: true
      t.belongs_to :project, null: false, foreign_key: true
      t.string :rol
      t.integer :working_hours
      t.string :working_hours_type
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
