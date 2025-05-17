class AddTimerToTests < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :timer, :integer
  end
end
