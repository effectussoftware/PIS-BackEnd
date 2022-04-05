class AddLeaderToPerson < ActiveRecord::Migration[6.0]
  def change
    change_table :people, bulk: true do |t|
      t.boolean :is_leader, default: false
      t.references :leader, null: true
    end
  end
end
