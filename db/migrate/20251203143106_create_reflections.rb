class CreateReflections < ActiveRecord::Migration[8.1]
  def change
    create_table :reflections do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.text :content
      t.integer :score
      t.integer :reflection_type

      t.timestamps
    end
  end
end
