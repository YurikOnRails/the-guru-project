class AddIndexesAndForeignKeysToTestResults < ActiveRecord::Migration[8.0]
  def change
    add_index :test_results, :user_id
    add_index :test_results, :test_id

    add_foreign_key :test_results, :users
    add_foreign_key :test_results, :tests
  end
end
