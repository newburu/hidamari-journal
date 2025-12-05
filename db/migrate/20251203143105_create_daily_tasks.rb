class CreateDailyTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :monthly_goal, null: true, foreign_key: true
      t.date :date
      t.string :title
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
