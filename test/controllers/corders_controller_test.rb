require 'test_helper'

class CordersControllerTest < ActionController::TestCase
  setup do
    @corder = corders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create corder" do
    assert_difference('Corder.count') do
      post :create, corder: { address: @corder.address, card_expires_on: @corder.card_expires_on, card_type: @corder.card_type, cart_id: @corder.cart_id, city: @corder.city, email: @corder.email, first_name: @corder.first_name, ip_address: @corder.ip_address, last_name: @corder.last_name, notes: @corder.notes, phone: @corder.phone, price: @corder.price, processed: @corder.processed, shipping_address: @corder.shipping_address, shipping_city: @corder.shipping_city, shipping_state: @corder.shipping_state, shipping_zip: @corder.shipping_zip, state: @corder.state, zip_code: @corder.zip_code }
    end

    assert_redirected_to corder_path(assigns(:corder))
  end

  test "should show corder" do
    get :show, id: @corder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @corder
    assert_response :success
  end

  test "should update corder" do
    patch :update, id: @corder, corder: { address: @corder.address, card_expires_on: @corder.card_expires_on, card_type: @corder.card_type, cart_id: @corder.cart_id, city: @corder.city, email: @corder.email, first_name: @corder.first_name, ip_address: @corder.ip_address, last_name: @corder.last_name, notes: @corder.notes, phone: @corder.phone, price: @corder.price, processed: @corder.processed, shipping_address: @corder.shipping_address, shipping_city: @corder.shipping_city, shipping_state: @corder.shipping_state, shipping_zip: @corder.shipping_zip, state: @corder.state, zip_code: @corder.zip_code }
    assert_redirected_to corder_path(assigns(:corder))
  end

  test "should destroy corder" do
    assert_difference('Corder.count', -1) do
      delete :destroy, id: @corder
    end

    assert_redirected_to corders_path
  end
end
