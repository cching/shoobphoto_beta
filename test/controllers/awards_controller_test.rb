require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  setup do
    @award = awards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:awards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post :create, award: { abbreviation: @award.abbreviation, award_date: @award.award_date, awarded_for: @award.awarded_for, definition: @award.definition, export_list_id: @award.export_list_id, time_period: @award.time_period, title: @award.title }
    end

    assert_redirected_to award_path(assigns(:award))
  end

  test "should show award" do
    get :show, id: @award
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @award
    assert_response :success
  end

  test "should update award" do
    patch :update, id: @award, award: { abbreviation: @award.abbreviation, award_date: @award.award_date, awarded_for: @award.awarded_for, definition: @award.definition, export_list_id: @award.export_list_id, time_period: @award.time_period, title: @award.title }
    assert_redirected_to award_path(assigns(:award))
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete :destroy, id: @award
    end

    assert_redirected_to awards_path
  end
end
