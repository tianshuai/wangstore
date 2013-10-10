class Category < ActiveRecord::Base


  ##常量
  #状态
  STATE = {
  	no: 0,
	ok: 1
  }

  #类型
  KIND = {
  	#文章
	article: 1,
	#no_set
	img: 2
  }

  ##过滤
  scope :order_b,		-> { order("sort DESC") }
  #父分类
  scope :one_level,		-> { where(pid: 0) }
  #开启的
  scope :available,		-> { where(state: STATE[:ok]) }
  #关闭的
  scope :unavailable,	-> { where(state: STATE[:no]) }
  #文章
  scope :article,		-> { where(kind: KIND[:article]) }
  #未定义类型
  scope :undefault,		-> { where(kind: KIND[:img]) }

  ##方法
  #父类级
  def self.parent_options(kind=1)
	def_option = ['--父类--', 0]
	case kind
	when 1
	  Category.one_level.article.available.collect{ |x| [x.name, x.id] }.unshift(def_option)
	when 2
	  Category.one_level.undefault.available.collect{ |x| [x.name, x.id] }.unshift(def_option)
	else
	  [ ['--父类--', 0] ]
	end
  end

  #类型说明
  def kind_str
	case self.kind
	when 1 then '文章'
	when 2 then '未定义'
	else
	  '未定义'
	end
  end


end
