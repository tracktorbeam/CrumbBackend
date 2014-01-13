require 'test_helper'

class StoreMessagesControllerTest < ActionController::TestCase
  setup do
    @store_message = store_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:store_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store_message" do
    assert_difference('StoreMessage.count') do
      post :create, store_message: { message_id: @store_message.message_id }
    end

    assert_redirected_to store_message_path(assigns(:store_message))
  end

  test "should show store_message" do
    get :show, id: @store_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @store_message
    assert_response :success
  end

  test "should update store_message" do
    put :update, id: @store_message, store_message: { message_id: @store_message.message_id }
    assert_redirected_to store_message_path(assigns(:store_message))
  end

  test "should destroy store_message" do
    assert_difference('StoreMessage.count', -1) do
      delete :destroy, id: @store_message
    end

    assert_redirected_to store_messages_path
  end
end
