require 'test_helper'

class PdfsControllerTest < ActionController::TestCase
  setup do
    @pdf = pdfs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pdfs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pdf" do
    assert_difference('Pdf.count') do
      post :create, pdf: {  }
    end

    assert_redirected_to pdf_path(assigns(:pdf))
  end

  test "should show pdf" do
    get :show, id: @pdf
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pdf
    assert_response :success
  end

  test "should update pdf" do
    patch :update, id: @pdf, pdf: {  }
    assert_redirected_to pdf_path(assigns(:pdf))
  end

  test "should destroy pdf" do
    assert_difference('Pdf.count', -1) do
      delete :destroy, id: @pdf
    end

    assert_redirected_to pdfs_path
  end
end
