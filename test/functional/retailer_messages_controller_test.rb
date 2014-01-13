require 'test_helper'

class RetailerMessagesControllerTest < ActionController::TestCase
  setup do
    @retailer_message = retailer_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retailer_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retailer_message" do
    assert_difference('RetailerMessage.count') do
      post :create, retailer_message: { message_id: @retailer_message.message_id }
    end

    assert_redirected_to retailer_message_path(assigns(:retailer_message))
  end

  test "should show retailer_message" do
    get :show, id: @retailer_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retailer_message
    assert_response :success
  end

  test "should update retailer_message" do
    put :update, id: @retailer_message, retailer_message: { message_id: @retailer_message.message_id }
    assert_redirected_to retailer_message_path(assigns(:retailer_message))
  end

  test "should destroy retailer_message" do
    assert_difference('RetailerMessage.count', -1) do
      delete :destroy, id: @retailer_message
    end

    assert_redirected_to retailer_messages_path
  end
end
