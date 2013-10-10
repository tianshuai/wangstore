class Post < ActiveRecord::Base

  ##验证
  validates_presence_of :title
  validates :title,                               length: { minimum: 2, maximum: 50 }

  validates :content,                             length: { maximum: 50000 }
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
    news: 1,
	#通用
	common: 2
  }

  #推荐
  STICK = {
	#未推荐
	no: 0,
	yes: 1
  }


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

end
