class AddDefaultBooleanValueToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :admin, from: nil, to: false
    change_column_default :users, :activated, from: nil, to: false
  end
end
