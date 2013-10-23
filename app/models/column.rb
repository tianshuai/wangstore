class Column < ActiveRecord::Base

  ##关系
  has_one :asset,				dependent: :destroy,  as: :relateable
  belongs_to :column_space
  belongs_to :user

  ##验证
  validates_presence_of :title,                    message: '标题不能为空'
  validates :title,                                length: { minimum: 2, maximum: 30, message: '长度大于2个字符且小于18个字符' }
  validates_presence_of :column_space_id,          message: '请选择栏目位'

  ##常量
  #类型
  KIND = {
	#图片
  	img: 1,
	#文字
	text: 2
  }


  ##过滤
  #排序
  scope :recent,      	-> { order("id DESC") }

end
