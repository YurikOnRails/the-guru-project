class CreateBadges < ActiveRecord::Migration[7.0]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.string :image_url, null: false
      t.string :rule_type, null: false
      t.string :rule_value, null: false

      t.timestamps
    end

    add_index :badges, :name, unique: true
  end
end
