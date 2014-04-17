require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: "Bob", email: "bob123@gmail.com", password: "12345678", roles: "Artist", is_approved: "true"}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should update user" do
    patch :update, id: @user, user: { name: "Jim", email: "bob@yahoo.com", password: @user.password, roles: "User"}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
  
end
