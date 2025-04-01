class ChangeUserIdToNullableInTestPassages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :test_passages, :user_id, true
  end
end
