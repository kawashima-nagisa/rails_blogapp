class CreateContactForms < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_forms do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
