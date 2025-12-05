require "test_helper"

class MandalaItemTest < ActiveSupport::TestCase
  test "should have self-referential association" do
    user = users(:one)
    annual_theme = AnnualTheme.create!(user: user, year: 2025, kanji: "挑", meaning: "Challenge")

    parent = MandalaItem.create!(annual_theme: annual_theme, content: "Center", is_center: true, position: 4)
    child = MandalaItem.create!(annual_theme: annual_theme, parent: parent, content: "Sub Goal", position: 0)

    assert_equal parent, child.parent
    assert_includes parent.children, child
  end
end
