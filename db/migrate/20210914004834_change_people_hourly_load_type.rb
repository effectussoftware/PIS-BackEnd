class ChangePeopleHourlyLoadType < ActiveRecord::Migration[6.0]
  def change
    change_column :people, :hourly_load, :string
  end
end
