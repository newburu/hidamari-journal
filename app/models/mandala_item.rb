class MandalaItem < ApplicationRecord
  belongs_to :annual_theme
  belongs_to :parent, class_name: 'MandalaItem', optional: true
  has_many :children, class_name: 'MandalaItem', foreign_key: 'parent_id', dependent: :destroy
end
