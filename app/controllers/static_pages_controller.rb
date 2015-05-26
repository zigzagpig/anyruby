class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
  	@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def help
  end
  
  def about  	
  end

  def contact  	
  end

  #登录游客帐号
  def qq
    user = User.find(6)
    log_in user
    remember(user)
    redirect_to root_url
  end

end
