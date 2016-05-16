require 'test_helper'

class WebcamsControllerTest < ActionController::TestCase
  setup do
    @webcam = webcams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webcams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webcam" do
    assert_difference('Webcam.count') do
      post :create, webcam: {  }
    end

    assert_redirected_to webcam_path(assigns(:webcam))
  end

  test "should show webcam" do
    get :show, id: @webcam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webcam
    assert_response :success
  end

  test "should update webcam" do
    patch :update, id: @webcam, webcam: {  }
    assert_redirected_to webcam_path(assigns(:webcam))
  end

  test "should destroy webcam" do
    assert_difference('Webcam.count', -1) do
      delete :destroy, id: @webcam
    end

    assert_redirected_to webcams_path
  end
end
