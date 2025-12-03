class AnnualTheme < ApplicationRecord
  belongs_to :user
  has_many :mandala_items, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy

  validates :year, presence: true, uniqueness: { scope: :user_id }
  validates :kanji, presence: true, length: { maximum: 1 }
end
