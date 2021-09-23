class ChangePeopleWorkingHours < ActiveRecord::Migration[6.0]
  def change
    rename_column :people, :hourly_load_hours, :working_hours
    remove_column :people, :hourly_load, :string
  end
end
