class AddStartedAtToTestPassages < ActiveRecord::Migration[7.0]
  def change
    add_column :test_passages, :started_at, :datetime
  end
end
