require 'test_helper'

class DemoControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get new_website" do
    get :new_website
    assert_response :success
  end

  test "should get show_website" do
    get :show_website
    assert_response :success
  end

  test "should get new_ask" do
    get :new_ask
    assert_response :success
  end

  test "should get show_ask" do
    get :show_ask
    assert_response :success
  end

end
