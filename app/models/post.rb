class Post < ActiveRecord::Base

  ##关系
  belongs_to :user
  belongs_to :category

  ##关系
  has_many :assets,         dependent: :destroy,  as: :relateable

  ##验证
  validates_presence_of :title,					  message: '请输入标题'
  validates :title,                               length: { minimum: 2, maximum: 50, message: '标题长度大于２小于５０' }

  validates :content,                             length: { maximum: 500000 }
  validates_presence_of :user_id,				  message: '请选择创建人'
  validates_presence_of :category_id,			  message: '请选择分类'

  ##常量
  #状态
  STATE = {
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  #是否发布状态
  PUBLISH = {
    no: 0,
    yes: 1
  }

  #类型
  KIND = {
    #文章
    article: 1,
	#通用
	common: 2
  }

  #推荐
  STICK = {
	#未推荐
	no: 0,
	yes: 1
  }

  ##过滤
  #文章
  scope :article,			-> { where(kind: KIND[:article]) }
  #最新的
  scope :recent,			-> { order("created_at DESC") }
  #按自定义排序
  scope :order_b,           -> { order("sort DESC") }
  #已发布的
  scope :published,         -> { where(publish: PUBLISH[:yes]) }
  #未发布的
  scope :unpublished,       -> { where(publish: PUBLISH[:no]) }
  #正常显示的
  scope :normal,            -> { where(state: STATE[:ok]) }
  #禁用的
  scope :forbid,            -> { where(state: STATE[:no]) }
  #推荐的
  scope :sticked,			-> { where(stick: STICK[:yes]) }


  ##方法
  #是否发布
  def published?
	return false if self.publish == PUBLISH[:no]
	return true
  end

  #是否禁用
  def forbid?
	return true if self.state == STATE[:no]
	return false
  end

  #链接地址
  def view_url
	''
  end

end
