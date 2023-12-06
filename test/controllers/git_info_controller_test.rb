require "test_helper"

class GitInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get git_info_index_url
    assert_response :success
  end

  test "should get show" do
    get git_info_show_url
    assert_response :success
  end
end
