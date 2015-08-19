require 'test_helper'

class NavLinksControllerTest < ActionController::TestCase
  setup do
    @nav_link = nav_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nav_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nav_link" do
    assert_difference('NavLink.count') do
      post :create, nav_link: { lft: @nav_link.lft, parent_id: @nav_link.parent_id, position: @nav_link.position, rgt: @nav_link.rgt, slug: @nav_link.slug, title: @nav_link.title }
    end

    assert_redirected_to nav_link_path(assigns(:nav_link))
  end

  test "should show nav_link" do
    get :show, id: @nav_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nav_link
    assert_response :success
  end

  test "should update nav_link" do
    patch :update, id: @nav_link, nav_link: { lft: @nav_link.lft, parent_id: @nav_link.parent_id, position: @nav_link.position, rgt: @nav_link.rgt, slug: @nav_link.slug, title: @nav_link.title }
    assert_redirected_to nav_link_path(assigns(:nav_link))
  end

  test "should destroy nav_link" do
    assert_difference('NavLink.count', -1) do
      delete :destroy, id: @nav_link
    end

    assert_redirected_to nav_links_path
  end
end
