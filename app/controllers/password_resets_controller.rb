class PasswordResetsController < ApplicationController


  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      sendcloud_mail_api(mail_to: @user.email, topic: "重置你的 anyruby 帐号",
        html_content: password_reset_html(@user.name,
          edit_password_reset_url(@user.reset_token, email: @user.email)))
      flash[:info] = "已发送重置密码链接到你的邮箱了哎"
      redirect_to root_url
    else  
      flash.now[:danger] = "真是的 输入的邮箱不存在啊"
      render 'new'
    end
  end

  def update
    if both_passwords_blank?
      flash.now[:danger] = "密码不能为空"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "密码重置成功."
      redirect_to @user
    else
      render 'edit'
    end
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

  def sendcloud_mail_api(mail_to: "695312886@qq.com", topic: "默认主题", html_content: "你已成功的从SendCloud发送了一封测试邮件，接下来快登录前台去完善账户信息吧！")
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



  private
    
    #获取用户参数
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    #密码和重置的密码都为空
    def both_passwords_blank?
          params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?
    end

    #事前过滤器
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    #确保是有效用户
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #检查令牌是否过期
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "重置链接已过期."
        redirect_to new_password_reset_url
      end
    end
end
