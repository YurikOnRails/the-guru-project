class RemoveUserIdFromTests < ActiveRecord::Migration[6.0]
  def change
    remove_column :tests, :user_id, :integer
  end
end
