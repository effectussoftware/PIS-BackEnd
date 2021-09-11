class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :budget

      t.timestamps
    end
  end
end
