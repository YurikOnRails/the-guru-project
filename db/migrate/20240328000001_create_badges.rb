class CreateBadges < ActiveRecord::Migration[7.0]
  def change
    create_table :badges do |t|
      t.string :title, null: false
      t.string :image_url, null: false
      t.string :rule_type, null: false
      t.jsonb :rule_params, null: false, default: {}
      t.text :description

      t.timestamps
    end
  end
end 