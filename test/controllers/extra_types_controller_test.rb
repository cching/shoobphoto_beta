require 'test_helper'

class ExtraTypesControllerTest < ActionController::TestCase
  setup do
    @extra_type = extra_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extra_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extra_type" do
    assert_difference('ExtraType.count') do
      post :create, extra_type: { multiple: @extra_type.multiple, name: @extra_type.name, required: @extra_type.required }
    end

    assert_redirected_to extra_type_path(assigns(:extra_type))
  end

  test "should show extra_type" do
    get :show, id: @extra_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @extra_type
    assert_response :success
  end

  test "should update extra_type" do
    patch :update, id: @extra_type, extra_type: { multiple: @extra_type.multiple, name: @extra_type.name, required: @extra_type.required }
    assert_redirected_to extra_type_path(assigns(:extra_type))
  end

  test "should destroy extra_type" do
    assert_difference('ExtraType.count', -1) do
      delete :destroy, id: @extra_type
    end

    assert_redirected_to extra_types_path
  end
end
