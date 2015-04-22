require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
  	@relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end
  
  test "关系模型应该合法" do
  		assert @relationship.valid?
  end
  
  test "没有关注者不通过" do
  	@relationship.follower_id = nil
  	assert_not @relationship.valid?
  end
  
  test "没有被关注者不通过" do
  	@relationship.followed_id = nil
  	assert_not @relationship.valid?
  end
end
