require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest

  test "user signup" do

    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { 
        username: "John", 
        email: "john.doe@gmail.com", 
        password: "password", 
        admin: true
        }}
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Welcome", response.body
    assert_select 'div.alert'
  end

  test "failed user signup" do

    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { 
        username: "J", 
        email: "john.doe123@gmail.com", 
        password: "password", 
        admin: false
        }}
    end
    assert_match "errors", response.body
  end
end