require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  
  def setup
	@micropost = microposts(:orange)
  end

  test "没登录之前发布微博跳转到登录路径" do
  	assert_no_difference 'Micropost.count' do
	  post :create, micropost: { content: "Lorem ipsum" }
	end
    assert_redirected_to login_url
  end

  test "没登录之前删除微博跳转到登录路径" do
	assert_no_difference 'Micropost.count' do
	  delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "没权限的人删除别人的微博会出错回首页" do
    log_in_as(users(:xiaokai))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end

end
