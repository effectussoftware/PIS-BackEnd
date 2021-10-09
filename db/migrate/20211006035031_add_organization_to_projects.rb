class AddOrganizationToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :organization, :string
  end
end
