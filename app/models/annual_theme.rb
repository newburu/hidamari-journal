class AnnualTheme < ApplicationRecord
  belongs_to :user
  has_many :mandala_items, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy

  validates :year, presence: true, uniqueness: { scope: :user_id }
  validates :kanji, presence: true, length: { maximum: 1 }

  after_create :create_center_mandala_item

  private

  def create_center_mandala_item
    mandala_items.create!(
      content: kanji,
      is_center: true,
      position: 4 # 3x3 grid center index (0-8)
    )
  end
end
