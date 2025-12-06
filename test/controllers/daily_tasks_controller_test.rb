require "test_helper"

class DailyTasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @monthly_goal = monthly_goals(:one)
    @daily_task = daily_tasks(:one)
    sign_in @user
  end

  test "should get index" do
    get daily_tasks_url
    assert_response :success
  end

  test "should create daily_task" do
    assert_difference("DailyTask.count") do
      post daily_tasks_url, params: { daily_task: { date: Date.today, title: "New Task" } }
    end

    assert_redirected_to daily_tasks_url(date: Date.today)
  end

  test "should update daily_task completion" do
    patch daily_task_url(@daily_task), params: { daily_task: { completed: true } }
    assert_redirected_to daily_tasks_url(date: @daily_task.date)
    @daily_task.reload
    assert @daily_task.completed
  end

  test "should destroy daily_task" do
    assert_difference("DailyTask.count", -1) do
      delete daily_task_url(@daily_task)
    end

    assert_redirected_to daily_tasks_url(date: @daily_task.date)
  end
end
