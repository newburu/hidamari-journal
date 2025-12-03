class CreateAnnualThemes < ActiveRecord::Migration[8.1]
  def change
    create_table :annual_themes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year
      t.string :kanji
      t.text :meaning

      t.timestamps
    end
  end
end
