require 'test_helper'

class GdocsControllerTest < ActionController::TestCase
  setup do
    @gdoc = gdocs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gdocs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gdoc" do
    assert_difference('Gdoc.count') do
      post :create, gdoc: {  }
    end

    assert_redirected_to gdoc_path(assigns(:gdoc))
  end

  test "should show gdoc" do
    get :show, id: @gdoc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gdoc
    assert_response :success
  end

  test "should update gdoc" do
    patch :update, id: @gdoc, gdoc: {  }
    assert_redirected_to gdoc_path(assigns(:gdoc))
  end

  test "should destroy gdoc" do
    assert_difference('Gdoc.count', -1) do
      delete :destroy, id: @gdoc
    end

    assert_redirected_to gdocs_path
  end
end
