class AddAuthorIdToTests < ActiveRecord::Migration[8.0]
  def change
    add_column :tests, :author_id, :integer, null: false, default: 0
  end
end
