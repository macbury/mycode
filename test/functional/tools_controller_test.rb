require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tool" do
    assert_difference('Tool.count') do
      post :create, :tool => { }
    end

    assert_redirected_to tool_path(assigns(:tool))
  end

  test "should show tool" do
    get :show, :id => tools(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tools(:one).to_param
    assert_response :success
  end

  test "should update tool" do
    put :update, :id => tools(:one).to_param, :tool => { }
    assert_redirected_to tool_path(assigns(:tool))
  end

  test "should destroy tool" do
    assert_difference('Tool.count', -1) do
      delete :destroy, :id => tools(:one).to_param
    end

    assert_redirected_to tools_path
  end
end
