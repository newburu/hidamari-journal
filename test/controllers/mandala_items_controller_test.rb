require "test_helper"

class MandalaItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @annual_theme = AnnualTheme.create!(user: @user, year: 2026, kanji: "成", meaning: "Growth")
    @mandala_item = @annual_theme.mandala_items.find_by(is_center: true)
    sign_in @user
  end

  test "should get edit" do
    get edit_mandala_item_url(@mandala_item)
    assert_response :success
  end

  test "should update mandala_item" do
    patch mandala_item_url(@mandala_item), params: { mandala_item: { content: "New Goal" } }
    assert_redirected_to chart_annual_theme_url(@annual_theme)
    @mandala_item.reload
    assert_equal "New Goal", @mandala_item.content
  end

  test "should sync center item with annual theme kanji" do
    # Kanji validation max 1 char
    patch mandala_item_url(@mandala_item), params: { mandala_item: { content: "更" } }
    @annual_theme.reload
    assert_equal "更", @annual_theme.kanji
  end

  test "should not edit other user's item" do
    other_user = users(:two)
    other_theme = AnnualTheme.create!(user: other_user, year: 2026, kanji: "別", meaning: "Other")
    other_item = other_theme.mandala_items.find_by(is_center: true)

    patch mandala_item_url(other_item), params: { mandala_item: { content: "Hacked" } }
    assert_redirected_to root_url
  end
end
