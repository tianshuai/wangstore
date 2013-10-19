class Asset < ActiveRecord::Base

  ##常量
  #类型
  KIND = {
    img: 1,
	word: 2,
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
  def url
	File.join(self.file_path, self.file_name)
  end

end
