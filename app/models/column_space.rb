class ColumnSpace < ActiveRecord::Base

  ##关系
  has_one :column
  belongs_to :user

  ##验证
  validates_presence_of :mark,                    message: '不能为空'
  validates :mark,                                length: { minimum: 2, maximum: 18, message: '长度大于2个字符且小于18个字符' }
  validates_uniqueness_of :mark,				　message: '标识已存在'

  ##常量
  #类型
  KIND = {
	#图片
  	img: 1,
	#文字
	text: 2
  }

  #状态
  STATE = {
  	no: 0,
	ok: 1
  }


  ##过滤
  #排序
  scope :recent,      	-> { order("id DESC") }
  scope :normal,		-> { where(state: STATE[:ok]) }



  ##方法 
  #栏目位下拉选择列表
  def self.select_options(kind = 1)
	self.normal.recent.collect{ |x| [x.name, x.id] }
  end

end
