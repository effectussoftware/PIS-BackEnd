class ProjectChange < ActiveRecord::Migration[6.0]
  def up
    change_column_null :projects, :end_date, true
    change_column_null :projects, :description, false
    add_column :projects, :project_state, :string, :null=>false
    add_column :projects, :project_type, :string, :null=>false
  end
  def down
    remove_column :projects, :end_date, :date
    remove_column :projects, :description, :string
    remove_column :projects, :project_state, :string
    remove_column :projects, :project_type, :string
  end
end