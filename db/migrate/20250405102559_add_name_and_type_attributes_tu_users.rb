class AddNameAndTypeAttributesTuUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :type, :string, null: false, default: 'User'
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_index :users, :type
  end
end
