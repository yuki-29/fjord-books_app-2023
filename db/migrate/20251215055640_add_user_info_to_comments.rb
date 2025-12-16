class AddUserInfoToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :user_name, :string
    add_column :comments, :user_email, :string
  end
end
