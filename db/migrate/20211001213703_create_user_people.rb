class CreateUserPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :user_people do |t|
      t.boolean :notify, default: false
      t.boolean :is_valid, default: true
      t.integer :user_id
      t.integer :person_id
      t.timestamps
    end
  end
end
