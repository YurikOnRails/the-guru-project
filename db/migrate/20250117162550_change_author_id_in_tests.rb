class ChangeAuthorIdInTests < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tests, :author_id, true
  end
end
