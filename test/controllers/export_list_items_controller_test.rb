require 'test_helper'

class ExportListItemsControllerTest < ActionController::TestCase
  setup do
    @export_list_item = export_list_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:export_list_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create export_list_item" do
    assert_difference('ExportListItem.count') do
      post :create, export_list_item: {  }
    end

    assert_redirected_to export_list_item_path(assigns(:export_list_item))
  end

  test "should show export_list_item" do
    get :show, id: @export_list_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @export_list_item
    assert_response :success
  end

  test "should update export_list_item" do
    patch :update, id: @export_list_item, export_list_item: {  }
    assert_redirected_to export_list_item_path(assigns(:export_list_item))
  end

  test "should destroy export_list_item" do
    assert_difference('ExportListItem.count', -1) do
      delete :destroy, id: @export_list_item
    end

    assert_redirected_to export_list_items_path
  end
end
