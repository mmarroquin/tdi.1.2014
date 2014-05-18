require 'test_helper'

class SftpsControllerTest < ActionController::TestCase
  setup do
    @sftp = sftps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sftps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sftp" do
    assert_difference('Sftp.count') do
      post :create, sftp: {  }
    end

    assert_redirected_to sftp_path(assigns(:sftp))
  end

  test "should show sftp" do
    get :show, id: @sftp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sftp
    assert_response :success
  end

  test "should update sftp" do
    patch :update, id: @sftp, sftp: {  }
    assert_redirected_to sftp_path(assigns(:sftp))
  end

  test "should destroy sftp" do
    assert_difference('Sftp.count', -1) do
      delete :destroy, id: @sftp
    end

    assert_redirected_to sftps_path
  end
end
