require "test_helper"

class AnnualThemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @annual_theme = AnnualTheme.create!(user: @user, year: 2024, kanji: "始", meaning: "Start")
    sign_in @user
  end

  test "should get index" do
    get annual_themes_url
    assert_response :success
  end

  test "should get new" do
    get new_annual_theme_url
    assert_response :success
  end

  test "should create annual_theme" do
    assert_difference("AnnualTheme.count") do
      post annual_themes_url, params: { annual_theme: { kanji: "新", meaning: "New stuff", year: 2025 } }
    end

    assert_redirected_to annual_theme_url(AnnualTheme.last)
  end

  test "should show annual_theme" do
    get annual_theme_url(@annual_theme)
    assert_response :success
  end

  test "should get edit" do
    get edit_annual_theme_url(@annual_theme)
    assert_response :success
  end

  test "should update annual_theme" do
    patch annual_theme_url(@annual_theme), params: { annual_theme: { kanji: "変", meaning: "Change" } }
    assert_redirected_to annual_theme_url(@annual_theme)
    @annual_theme.reload
    assert_equal "変", @annual_theme.kanji
  end

  test "should destroy annual_theme" do
    assert_difference("AnnualTheme.count", -1) do
      delete annual_theme_url(@annual_theme)
    end

    assert_redirected_to annual_themes_url
  end

  test "should not access other user's theme" do
    other_user = users(:two)
    # user :one already has a theme for 2024 (from setup), so user :two can also have 2024
    other_theme = AnnualTheme.create!(user: other_user, year: 2024, kanji: "別", meaning: "Other")

    assert_raises ActiveRecord::RecordNotFound do
      get annual_theme_url(other_theme)
    end
  end
end
