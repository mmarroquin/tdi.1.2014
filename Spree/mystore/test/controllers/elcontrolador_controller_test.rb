require 'test_helper'

class ElcontroladorControllerTest < ActionController::TestCase
  test "should get elmetodo" do
    get :elmetodo
    assert_response :success
  end

end
