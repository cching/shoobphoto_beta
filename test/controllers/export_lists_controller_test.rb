require 'test_helper'

class ExportListsControllerTest < ActionController::TestCase
  setup do
    @export_list = export_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:export_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create export_list" do
    assert_difference('ExportList.count') do
      post :create, export_list: {  }
    end

    assert_redirected_to export_list_path(assigns(:export_list))
  end

  test "should show export_list" do
    get :show, id: @export_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @export_list
    assert_response :success
  end

  test "should update export_list" do
    patch :update, id: @export_list, export_list: {  }
    assert_redirected_to export_list_path(assigns(:export_list))
  end

  test "should destroy export_list" do
    assert_difference('ExportList.count', -1) do
      delete :destroy, id: @export_list
    end

    assert_redirected_to export_lists_path
  end
end
