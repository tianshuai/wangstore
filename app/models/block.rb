class Block < ActiveRecord::Base

  ##关系
  belongs_to :user

  ##验证
  validates_presence_of :mark,                    message: '标识不能为空'
  validates :mark,                                length: { minimum: 2, maximum: 18, message: '长度大于2个字符且小于18个字符' }
  validates_uniqueness_of :mark,				　message: '标识已存在'
  validates_presence_of :title,                    message: '说明不能为空'

  ##常量
  #类型
  KIND = {
	#图片
  	undefault1: 1,
	#文字
  	undefault2: 2
  }


  ##过滤
  #排序
  scope :recent,      	-> { order("id DESC") }
	 
end
