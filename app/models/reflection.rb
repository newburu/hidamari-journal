class Reflection < ApplicationRecord
  belongs_to :user

  enum :reflection_type, { daily: 0, monthly: 1 }
end
