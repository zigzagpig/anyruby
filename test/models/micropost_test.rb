require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
  	@user = users(:zigzagpig)
	#这行代码不符合常见做法
	@micropost = @user.microposts.build(content: "无意苦争春")
  end

  test "微博模型必须是合法的" do
  	assert @micropost.valid?
  end

  test "微博的所属用户必须存在" do
  	@micropost.user_id = nil
  	assert_not @micropost.valid?
  end

  test "微博内容必须存在" do
  	@micropost.content = " "
  	assert_not @micropost.valid?
  end

  test "微博内容最多包含140个字" do
  	@micropost.content = "我" * 141
	assert_not @micropost.valid?
  end

  test "必须按照发布时间来排序" do
	assert_equal Micropost.first, microposts(:most_recent)
  end

end
