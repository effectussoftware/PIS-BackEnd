class AddPersonRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :roles, :text, array: true, default: []
  end
end
