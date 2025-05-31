class CreateTestPassages < ActiveRecord::Migration[8.0]
  def change
    create_table :test_passages do |t|
      t.references :user, null: true, foreign_key: true
      t.references :test, null: false, foreign_key: true
      t.references :current_question, null: true, foreign_key: { to_table: :questions }
      t.integer :correct_questions, default: 0
      t.datetime :started_at
      t.boolean :success, default: false

      t.timestamps
    end

    add_index :test_passages, :started_at
    add_index :test_passages, :success
  end
end
