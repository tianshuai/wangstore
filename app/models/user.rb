class User < ActiveRecord::Base

  #密码验证
  has_secure_password

  ##验证
  #用户名
  validates :name, 			presence: true
  #邮箱
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  #email转换小写,确保唯一性
  before_save { self.email = email.downcase }

end
