
class CreateUserProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :user_projects do |t|
      t.boolean :notification_active, default: false
      t.boolean :not_seen, default: true
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end

    # user_person
  end
end
