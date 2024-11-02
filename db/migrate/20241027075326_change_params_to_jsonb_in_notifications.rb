class ChangeParamsToJsonbInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column :notifications, :params, :jsonb, using: "params::jsonb"
  end
end
