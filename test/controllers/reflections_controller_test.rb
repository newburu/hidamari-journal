require "test_helper"

class ReflectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @reflection = reflections(:one)
    sign_in @user
  end

  test "should get index" do
    get reflections_url
    assert_response :success
  end

  test "should get new" do
    get new_reflection_url
    assert_response :success
  end

  test "should create reflection" do
    assert_difference("Reflection.count") do
      post reflections_url, params: { reflection: { content: @reflection.content, date: @reflection.date, reflection_type: @reflection.reflection_type, score: @reflection.score } }
    end

    assert_redirected_to reflections_url
  end

  test "should show reflection" do
    get reflection_url(@reflection)
    assert_response :success
  end

  test "should get edit" do
    get edit_reflection_url(@reflection)
    assert_response :success
  end

  test "should update reflection" do
    patch reflection_url(@reflection), params: { reflection: { content: @reflection.content, date: @reflection.date, reflection_type: @reflection.reflection_type, score: @reflection.score } }
    assert_redirected_to reflections_url
  end

  test "should destroy reflection" do
    assert_difference("Reflection.count", -1) do
      delete reflection_url(@reflection)
    end

    assert_redirected_to reflections_url
  end

  test "should not access other user's reflections" do
    other_user = users(:two)
    other_reflection = Reflection.create!(user: other_user, date: Date.today, content: "Other's reflection", reflection_type: :daily, score: 5)

    assert_raises ActiveRecord::RecordNotFound do
      get reflection_url(other_reflection)
    end

    assert_raises ActiveRecord::RecordNotFound do
      get edit_reflection_url(other_reflection)
    end

    assert_raises ActiveRecord::RecordNotFound do
      patch reflection_url(other_reflection), params: { reflection: { content: "Hacked" } }
    end

    assert_raises ActiveRecord::RecordNotFound do
      delete reflection_url(other_reflection)
    end
  end
end
