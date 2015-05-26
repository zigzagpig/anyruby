class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)	
    if @user.save
      url = edit_account_activation_url(@user.activation_token, email: @user.email)
      html = account_activation_html(@user.name, url)
      sendcloud_mail_api(mail_to: @user.email, topic: "欢迎激活 anyruby 帐号",
        html_content: html)
      flash[:info] = "请检查你的邮箱以激活帐号."
  	  redirect_to root_url
  	else
  	  render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "改好了哟"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "删除成功了"
    redirect_to users_url
  end

  #获取当前页面用户收听的人
  def following
    @title = "收听"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  #获取当前页面用户的听众
  def followers
    @title = "听众"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def sendcloud_mail_api(mail_to: "695312886@qq.com", topic: "默认主题", html_content: "默认地你已成功的从SendCloud发送了一封测试邮件，接下来快登录前台去完善账户信息吧！")
      response = RestClient.post "http://sendcloud.sohu.com/webapi/mail.send.json",
      :api_user => "anyruby",
      :api_key => "EdI20d5yIWyqzEAB",
      :from => "no-reply@anyruby.com",
      :fromname => "Anyruby",
      :to => mail_to,
      :subject => topic,
      :html => html_content
      return response
    end
  
    def account_activation_html(user_to_be_send, url_to_link)
      "
  
        <h1>Anyruby</h1>
        <p>你好啊 #{user_to_be_send},</p>
          <p>
            欢迎注册 anyruby 帐号! 请点击下面的链接以激活帐户:
        </p>
        <a href=\"#{url_to_link}\" title=\"#{url_to_link}\">点我激活</a>
  
      "
    end
  
    def password_reset_html(user_to_be_send, url_to_link)
      "
  
        <h1>重置密码</h1>
        <p>#{user_to_be_send}, 点击下面的链接重置密码吧:</p>
        <a href=\"#{url_to_link}\" title=\"#{url_to_link}\">点我改密码</a>
        <p>这个链接仅在两小时内有效.</p>
        <p>
           如果你没有请求重置密码，请忽视本邮件，你的密码将保持不变。
        </p>
  
      "
    end
  
    def sendcloud_test(user_to_be_send, url_to_link)
      "
  
        <a href=\"#{url_to_link}\" title=\"#{url_to_link}\">激活</a>
        你已成功的从SendCloud发送了一封测试邮件，接下来快登录前台去完善账户信息吧！
  
      "
    end

end
