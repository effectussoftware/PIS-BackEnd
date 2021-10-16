class Change < ActiveRecord::Migration[6.0]
  def change
    rename_column :person_projects, :rol, :role
  end
end
