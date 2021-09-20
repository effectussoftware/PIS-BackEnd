class AddResetPasswordFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :needs_password_reset, :boolean, default: true
  end
end
