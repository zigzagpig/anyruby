require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  test "建立收听关系需要先收听" do
  	assert_no_difference 'Relationship.count' do
	  post :create
	end
    assert_redirected_to login_url
  end

  test "摧毁收听关系需要先登录" do
	assert_no_difference 'Relationship.count' do
	  delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
