require 'test_helper'

class DprojectsControllerTest < ActionController::TestCase
  setup do
    @dproject = dprojects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dprojects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dproject" do
    assert_difference('Dproject.count') do
      post :create, dproject: { completed_at: @dproject.completed_at, description: @dproject.description, id: @dproject.id, scode: @dproject.scode }
    end

    assert_redirected_to dproject_path(assigns(:dproject))
  end

  test "should show dproject" do
    get :show, id: @dproject
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dproject
    assert_response :success
  end

  test "should update dproject" do
    patch :update, id: @dproject, dproject: { completed_at: @dproject.completed_at, description: @dproject.description, id: @dproject.id, scode: @dproject.scode }
    assert_redirected_to dproject_path(assigns(:dproject))
  end

  test "should destroy dproject" do
    assert_difference('Dproject.count', -1) do
      delete :destroy, id: @dproject
    end

    assert_redirected_to dprojects_path
  end
end
