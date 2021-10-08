class CreateTechnologies < ActiveRecord::Migration[6.0]
  def change
    create_table :technologies do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :technologies, :name, unique: true
  end
end
