require 'test_helper'

class RemoteFilesControllerTest < ActionController::TestCase
  setup do
    @remote_file = remote_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:remote_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create remote_file" do
    assert_difference('RemoteFile.count') do
      post :create, :remote_file => @remote_file.attributes
    end

    assert_redirected_to remote_file_path(assigns(:remote_file))
  end

  test "should show remote_file" do
    get :show, :id => @remote_file.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @remote_file.to_param
    assert_response :success
  end

  test "should update remote_file" do
    put :update, :id => @remote_file.to_param, :remote_file => @remote_file.attributes
    assert_redirected_to remote_file_path(assigns(:remote_file))
  end

  test "should destroy remote_file" do
    assert_difference('RemoteFile.count', -1) do
      delete :destroy, :id => @remote_file.to_param
    end

    assert_redirected_to remote_files_path
  end
end
