class DropInquiriesTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :inquiries
  end

  def down
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
