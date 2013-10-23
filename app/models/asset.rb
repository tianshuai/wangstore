class Asset < ActiveRecord::Base

  #同时删除mongodb中存储的图片
  before_destroy :delete_for_file

  #关联
  belongs_to :relateable,   polymorphic: true

  ##常量
  #类型
  KIND = {
    editor: 1,
	cover: 2,
	pdf: 3,
	excl: 4,
	other: 10
  }

  #状态
  STATE = {
  	no: 0,
	ok: 1
  }


  ## 方法
  #图片路径
  def url(size = 'o')
	File.join(self.file_path, size, self.file_name)
  end


  ##私有方法
  private

  # 删除时同时删除源文件
  def delete_for_file
	['o','b','m','s'].each do |i|
	  path = File.join( Rails.root, CONF['asset_path'], self.url(i) )
	  File.delete( path ) if File.exist?( path )
	end

  end

end
