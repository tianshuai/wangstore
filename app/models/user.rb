# encoding: utf-8
class User < ActiveRecord::Base

  #include ActiveModel::SecurePassword
  include ActiveModel::ForbiddenAttributesProtection


  ##关系
  #内嵌表：用户详细信息
  #embeds_one :profile
  #has_many :posts,            dependent: :destroy
  #has_many :arts,            dependent: :destroy
  #has_many :blocks
  #has_many :block_spaces


  #注册时把邮箱转换为小写字符
  before_save { |user| user.email = email.downcase }

  #创建用户登录标识(唯一随机数)
  before_create :create_remember_token

  #创建用户登录标识(唯一随机数)
  #before_create :create_remember_token

  #保护字段(在rails4.0中放在controller负责)
  #attr_protected :role_id

  #密码自动加密
  has_secure_password

  ##常量
  #角色
  ROLE_ID={
    #user
    user: 1,
    #editor
    editor: 2,
    #admin
    admin: 7,
    #system
    system: 8

  }
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  TYPE = {
    #学生
    student: 1,
    #老师
    teacher: 2,
    #公司
    company: 3
  }
  #性别
  SEX = {
    secret: 0,
    boy: 1,
    girl: 2
  }
  #验证邮箱格式
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ##验证
  validates_presence_of :name,                    message: '不能为空'
  validates :name,                                length: { minimum: 2, maximum: 18, message: '长度大于2个字符且小于18个字符' }
  validates_uniqueness_of :name,				　message: '用户名已存在'


  validates_presence_of :email,                   message: '不能为空'
  validates :email,                               format: { with: VALID_EMAIL_REGEX,  message: '格式不正确' },
                                                  uniqueness: { case_sensitive: false, message: '已经存在!' }

  validates :password,                            length: { minimum: 6,maximum: 18, message: '长度大于6个字符且小于18个字符' },
												  unless: lambda {|u| u.password.nil? }
  validates_presence_of :password,                message: '不能为空', unless: lambda {|u| u.password.nil? }
  #validates_presence_of :password_confirmation,   message: '不能为空'


  ##属性


  ##过滤
  #用户排序
  scope :recent,      	-> { desc(:_id) }
  #学生
  scope :students,    	-> { where(type: TYPE[:student]) }
  #最近登录排序
  scope :last_order,	-> { desc(:last_time) }

  ##
  #方法



  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


private

  #创建用户登录标识
  def create_remember_token
    self.remember_token =  User.encrypt(User.new_remember_token)
  end

  
end

