class DailyTask < ApplicationRecord
  belongs_to :user
  belongs_to :monthly_goal, optional: true
end
