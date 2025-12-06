class CreateMandalaItems < ActiveRecord::Migration[8.1]
  def change
    create_table :mandala_items do |t|
      t.references :annual_theme, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :mandala_items }
      t.string :content
      t.integer :position
      t.boolean :is_center

      t.timestamps
    end
  end
end
