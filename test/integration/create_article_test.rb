require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest

  setup do
    @regular_user = User.create(username: "johndoe", email: "johndoe@example.com", password: "password", admin: false)
    sign_in_as(@regular_user)
    @category1 = Category.create(name: "Sports")
    @category1 = Category.create(name: "Lifestyle")
  end

  test "get new article form and create article" do

    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: "Brand new article", description: "Brand new description", categories: [1,2] }}
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "successfully", response.body
  end

  test "get new article form and fail create article" do

    get "/articles/new"
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: "Bra", description: "Brand new description", categories: [1,2] }}
    end
    assert_match "errors", response.body
  end
end
