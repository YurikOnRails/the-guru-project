class CreateTestResults < ActiveRecord::Migration[8.0]
  def change
    create_table :test_results do |t|
      # По умолчанию для references тип данных integer, поэтому их явно не указываю
      t.references :user, null: false, foreign_key: true
      t.references :test, null: false, foreign_key: true

      t.timestamps
    end
  end
end
