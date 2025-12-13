require "test_helper"

class MonthlyGoalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @annual_theme = AnnualTheme.create!(user: @user, year: 2026, kanji: "成", meaning: "Growth")
    @center_item = @annual_theme.mandala_items.find_by(is_center: true)
    @sub_item = @annual_theme.mandala_items.create!(parent: @center_item, position: 1, content: "Health", is_center: false)

    @monthly_goal = @annual_theme.monthly_goals.create!(
      user: @user,
      month: 1,
      goal: "Run 5km daily",
      mandala_item: @sub_item
    )
    sign_in @user
  end

  test "should get index" do
    get annual_theme_monthly_goals_url(@annual_theme)
    assert_response :success
  end

  test "should get new" do
    get new_annual_theme_monthly_goal_url(@annual_theme)
    assert_response :success
  end

  test "should create monthly_goal" do
    assert_difference("MonthlyGoal.count") do
      post annual_theme_monthly_goals_url(@annual_theme), params: { monthly_goal: { month: 2, goal: "Read 2 books", mandala_item_id: @sub_item.id } }
    end

    assert_redirected_to annual_theme_monthly_goals_url(@annual_theme)

    last_goal = MonthlyGoal.last
    assert_equal 2, last_goal.month
    assert_equal @sub_item, last_goal.mandala_item
  end

  test "should get edit" do
    get edit_annual_theme_monthly_goal_url(@annual_theme, @monthly_goal)
    assert_response :success
  end

  test "should update monthly_goal" do
    patch annual_theme_monthly_goal_url(@annual_theme, @monthly_goal), params: { monthly_goal: { goal: "Updated Goal" } }
    assert_redirected_to annual_theme_monthly_goals_url(@annual_theme)
    @monthly_goal.reload
    assert_equal "Updated Goal", @monthly_goal.goal
  end

  test "should destroy monthly_goal" do
    assert_difference("MonthlyGoal.count", -1) do
      delete annual_theme_monthly_goal_url(@annual_theme, @monthly_goal)
    end

    assert_redirected_to annual_theme_monthly_goals_url(@annual_theme)
  end

  test "should not access other user's monthly goals" do
    other_user = users(:two)
    other_annual_theme = AnnualTheme.create!(user: other_user, year: 2027, kanji: "他", meaning: "Other")
    other_monthly_goal = other_annual_theme.monthly_goals.create!(
      user: other_user,
      month: 1,
      goal: "Other user's goal"
    )

    assert_raises ActiveRecord::RecordNotFound do
      get edit_annual_theme_monthly_goal_url(other_annual_theme, other_monthly_goal)
    end

    assert_raises ActiveRecord::RecordNotFound do
      patch annual_theme_monthly_goal_url(other_annual_theme, other_monthly_goal), params: { monthly_goal: { goal: "Hacked" } }
    end

    assert_raises ActiveRecord::RecordNotFound do
      delete annual_theme_monthly_goal_url(other_annual_theme, other_monthly_goal)
    end
  end
end
