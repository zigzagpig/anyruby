class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  					format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  # 返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
	  BCrypt::Password.create(string, cost: cost)
  end

  #返回一个随机令牌
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #为了持久会话，在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #如果指定的令牌和摘要匹配，返回true
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #忘记用户
  def forget
    update_attribute(:remember_digest, nil)
  end

  #设置重置密码相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #发送密码重设邮件
  def send_password_reset_email
    sendcloud_mail_api(mail_to: self.email, topic: "重置你的 anyruby 帐号",
        html_content: sendcloud_test(self.name,
          edit_password_reset_url(@user.reset_token, email: @user.email)))
  end

  #判断密码重置链接是否过期（2小时）
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  #实现动态流原型  完整实现 ＝ 12 章
  def feed
    Micropost.where("user_id = ?", id)
  end



  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

