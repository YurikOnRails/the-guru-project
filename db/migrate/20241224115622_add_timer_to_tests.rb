class AddTimerToTests < ActiveRecord::Migration[8.0]
  def change
    add_column :tests, :timer_minutes, :integer
    add_index :tests, :timer_minutes
  end
end
