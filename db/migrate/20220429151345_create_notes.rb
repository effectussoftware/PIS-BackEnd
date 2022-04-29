class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :text, null: false
      t.belongs_to :project
      t.timestamps
    end
  end
end
