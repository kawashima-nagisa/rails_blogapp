class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
  end
end
