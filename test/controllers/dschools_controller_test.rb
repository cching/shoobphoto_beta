require 'test_helper'

class DschoolsControllerTest < ActionController::TestCase
  setup do
    @dschool = dschools(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dschools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dschool" do
    assert_difference('Dschool.count') do
      post :create, dschool: { name: @dschool.name, scode: @dschool.scode }
    end

    assert_redirected_to dschool_path(assigns(:dschool))
  end

  test "should show dschool" do
    get :show, id: @dschool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dschool
    assert_response :success
  end

  test "should update dschool" do
    patch :update, id: @dschool, dschool: { name: @dschool.name, scode: @dschool.scode }
    assert_redirected_to dschool_path(assigns(:dschool))
  end

  test "should destroy dschool" do
    assert_difference('Dschool.count', -1) do
      delete :destroy, id: @dschool
    end

    assert_redirected_to dschools_path
  end
end
