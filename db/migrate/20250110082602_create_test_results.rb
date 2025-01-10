class CreateTestResults < ActiveRecord::Migration[8.0]
  def change
    create_table :test_results do |t|
      t.integer :user_id
      t.integer :test_id
      t.boolean :completed
      t.integer :score

      t.timestamps
    end
  end
end
