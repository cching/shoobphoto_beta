require 'test_helper'

class StudentImagesControllerTest < ActionController::TestCase
  setup do
    @student_image = student_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_image" do
    assert_difference('StudentImage.count') do
      post :create, student_image: { package_id: @student_image.package_id, student_id: @student_image.student_id }
    end

    assert_redirected_to student_image_path(assigns(:student_image))
  end

  test "should show student_image" do
    get :show, id: @student_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_image
    assert_response :success
  end

  test "should update student_image" do
    patch :update, id: @student_image, student_image: { package_id: @student_image.package_id, student_id: @student_image.student_id }
    assert_redirected_to student_image_path(assigns(:student_image))
  end

  test "should destroy student_image" do
    assert_difference('StudentImage.count', -1) do
      delete :destroy, id: @student_image
    end

    assert_redirected_to student_images_path
  end
end
