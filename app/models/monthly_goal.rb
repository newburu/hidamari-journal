class MonthlyGoal < ApplicationRecord
  belongs_to :user
  belongs_to :annual_theme
  belongs_to :mandala_item, optional: true
end
