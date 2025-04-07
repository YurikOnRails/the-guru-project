class ChangeNameToNullableInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :name, true
  end
end
