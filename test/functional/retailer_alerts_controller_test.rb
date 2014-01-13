require 'test_helper'

class RetailerAlertsControllerTest < ActionController::TestCase
  setup do
    @retailer_alert = retailer_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retailer_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retailer_alert" do
    assert_difference('RetailerAlert.count') do
      post :create, retailer_alert: { alert_id: @retailer_alert.alert_id }
    end

    assert_redirected_to retailer_alert_path(assigns(:retailer_alert))
  end

  test "should show retailer_alert" do
    get :show, id: @retailer_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retailer_alert
    assert_response :success
  end

  test "should update retailer_alert" do
    put :update, id: @retailer_alert, retailer_alert: { alert_id: @retailer_alert.alert_id }
    assert_redirected_to retailer_alert_path(assigns(:retailer_alert))
  end

  test "should destroy retailer_alert" do
    assert_difference('RetailerAlert.count', -1) do
      delete :destroy, id: @retailer_alert
    end

    assert_redirected_to retailer_alerts_path
  end
end
