require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:xiaokai)
  end

  test "微博相关的测试" do
  	log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
  
    #无效提交
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    
    #有效提交
    content = "我还有要守护的爱人，所以没什么能打败我。－－亚丝娜"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    #删除一个微博
    assert_select 'a', text: '删除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    
    #访问一个用户的个人页面
    get user_path(users(:zigzagpig))
    assert_select 'a', text: '删除', count: 0
  end
end
