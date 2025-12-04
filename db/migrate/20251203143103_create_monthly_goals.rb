class CreateMonthlyGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :monthly_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :annual_theme, null: false, foreign_key: true
      t.references :mandala_item, null: true, foreign_key: true
      t.integer :month
      t.text :goal

      t.timestamps
    end
  end
end
