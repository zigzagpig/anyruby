class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  	  if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "帐号未激活. "
        message += "先去你的邮箱点击激活链接啊."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  	  flash.now[:danger] = '不合法的邮箱密码匹配'	#完全正确
  	  render 'new'
  	end
  end

  def destroy
    log_out if logged_in?    
    redirect_to root_url
  end
end
