require 'test_helper'

class ECommercesControllerTest < ActionController::TestCase
  setup do
    @e_commerce = e_commerces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:e_commerces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create e_commerce" do
    assert_difference('ECommerce.count') do
      post :create, e_commerce: {  }
    end

    assert_redirected_to e_commerce_path(assigns(:e_commerce))
  end

  test "should show e_commerce" do
    get :show, id: @e_commerce
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @e_commerce
    assert_response :success
  end

  test "should update e_commerce" do
    patch :update, id: @e_commerce, e_commerce: {  }
    assert_redirected_to e_commerce_path(assigns(:e_commerce))
  end

  test "should destroy e_commerce" do
    assert_difference('ECommerce.count', -1) do
      delete :destroy, id: @e_commerce
    end

    assert_redirected_to e_commerces_path
  end
end
