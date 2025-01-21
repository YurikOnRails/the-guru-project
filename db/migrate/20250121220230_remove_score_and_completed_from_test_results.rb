class RemoveScoreAndCompletedFromTestResults < ActiveRecord::Migration[8.0]
  def change
    remove_column :test_results, :score, :integer
    remove_column :test_results, :completed, :boolean
  end
end
