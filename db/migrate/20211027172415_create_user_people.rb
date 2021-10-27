class CreateUserPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :user_people do |t|
      t.boolean :notification_active, default: false
      t.boolean :not_seen, default: true
      t.integer :user_id
      t.integer :person_id
      t.timestamps
    end

    add_index :user_people, :user_id
    add_index :user_people, :person_id
  end
end
