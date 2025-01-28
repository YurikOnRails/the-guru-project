class AddForeignKeysToTestResults < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :test_results, :users
    add_foreign_key :test_results, :tests
  end
end