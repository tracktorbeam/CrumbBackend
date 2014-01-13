require 'test_helper'

class StoreAlertsControllerTest < ActionController::TestCase
  setup do
    @store_alert = store_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:store_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store_alert" do
    assert_difference('StoreAlert.count') do
      post :create, store_alert: { alert_id: @store_alert.alert_id }
    end

    assert_redirected_to store_alert_path(assigns(:store_alert))
  end

  test "should show store_alert" do
    get :show, id: @store_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @store_alert
    assert_response :success
  end

  test "should update store_alert" do
    put :update, id: @store_alert, store_alert: { alert_id: @store_alert.alert_id }
    assert_redirected_to store_alert_path(assigns(:store_alert))
  end

  test "should destroy store_alert" do
    assert_difference('StoreAlert.count', -1) do
      delete :destroy, id: @store_alert
    end

    assert_redirected_to store_alerts_path
  end
end
