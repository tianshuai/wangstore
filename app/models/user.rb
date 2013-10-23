# encoding: utf-8
class User < ActiveRecord::Base

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
    system: 9

  }
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  KIND = {
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


  ##过滤
  #用户排序
  scope :recent,      	-> { order("id DESC") }
  #学生
  scope :students,    	-> { where(kind: KIND[:student]) }
  #最近登录排序
  scope :last_order,	-> { desc(:last_time) }

  ##
  #方法

  #账户是否被禁用?
  def forbid?
	return true if self.state==STATE[:no]
	return false
  end

  #用户类型
  def kind_str
	case self.kind
	when 1 then '学生'
	when 2 then '老师'
	else
	  '未定义'
	end
  end

  #权限说明
  def role_str
	case self.role_id
	when 1 then '普通'
	when 2 then '编辑'
	when 7 then '管理员'
	when 8 then '系统管理员'
    end
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  ##私有方法
  private

  #创建用户登录标识
  def create_remember_token
    self.remember_token =  User.encrypt(User.new_remember_token)
  end

  
end

