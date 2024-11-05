class AddSocialLinksToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :github, :string
  end
end
