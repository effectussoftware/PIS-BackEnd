class ProjectChange < ActiveRecord::Migration[6.0]
  def change
    change_column_null :projects, :description, false
    change_column_null :projects, :end_date, true

    change_table :projects, bulk: true do |t|
      t.string :project_state, null: false
      t.string :project_type, null: false
      t.index :name, unique: true
    end
  end
end
