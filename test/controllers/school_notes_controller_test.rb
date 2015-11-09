require 'test_helper'

class SchoolNotesControllerTest < ActionController::TestCase
  setup do
    @school_note = school_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_note" do
    assert_difference('SchoolNote.count') do
      post :create, school_note: { address: @school_note.address, cdscode: @school_note.cdscode, city_id: @school_note.city_id, district_id: @school_note.district_id, name: @school_note.name, phone: @school_note.phone, principle: @school_note.principle, secretary: @school_note.secretary }
    end

    assert_redirected_to school_note_path(assigns(:school_note))
  end

  test "should show school_note" do
    get :show, id: @school_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @school_note
    assert_response :success
  end

  test "should update school_note" do
    patch :update, id: @school_note, school_note: { address: @school_note.address, cdscode: @school_note.cdscode, city_id: @school_note.city_id, district_id: @school_note.district_id, name: @school_note.name, phone: @school_note.phone, principle: @school_note.principle, secretary: @school_note.secretary }
    assert_redirected_to school_note_path(assigns(:school_note))
  end

  test "should destroy school_note" do
    assert_difference('SchoolNote.count', -1) do
      delete :destroy, id: @school_note
    end

    assert_redirected_to school_notes_path
  end
end
