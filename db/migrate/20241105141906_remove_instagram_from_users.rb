class RemoveInstagramFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :instagram, :string
  end
end
