# encoding: utf-8
module ImageUnit

  class Upload
  
    #保存图片
    #type::1作品图片,／２.编辑器图片；３.栏目块图片
    def self.save_asset(file,type,options={})

	  # 初始化参数
	  user_id = options[:user_id] || 0
	  o_filename = options[:filename] || ''

	  image_io= open(file)

      #用minimagick读取文件
      image_mini = MiniMagick::Image.read(image_io)

      result = {}
	  # 通过ｔｙｐｅ参数查找附件配置要求
      case type
      when 1 then resize = CONF['image_art_format']
      when 2 then resize = CONF['image_editor_format']
      else
        resize = CONF['image_editor_format']
      end

	  #判断格式
	  set_format = CONF['verify_img_type']
      format = result[:format] = image_mini[:format]
	  return { message: "只支持JPG、JPEG、PNG、GIF文件", result: false } unless set_format.include?(format)

      #整数转换为字节/ 验证附件大小
      verify_size = (resize['max_size'] || 5).to_i.megabytes
      size = result[:size] = image_mini[:size]
	  return { message: "文件大小不要超过5Mb", result: false } unless verify_size > size

	  # 验证宽高
	  min_w_h = resize['min_w_h']
	  return { message: "图片最低分辨率为#{min_w_h.first}x#{min_w_h.last}", result: false } if min_w_h.first > image_mini[:width] or min_w_h.last > image_mini[:height]

	  # 获取路径
	  path_root = CONF['asset_path']
	  date_dir = Time.now.year.to_s + ( Time.now.month > 6 ? 'b' : 'a' )
	  path_s = File.join(CONF['image_editor_format']['path'], date_dir)
	  path = File.join(path_root, path_s )
	  #如果目录不存在则创建
	  Mf::mkdirs(path)
	  #创建缩略图文件夹
	  if(!File.directory?(File.join(path, 'o')))
		#Dir.mkdir(File.join(path, 'o'))
		#Dir.mkdir(File.join(path, 'b'))
		#Dir.mkdir(File.join(path, 'm'))
		#Dir.mkdir(File.join(path, 's'))
	  end

	  # 生成文件名 
	  n_filename = Mf::g_filename( (user_id.to_s + o_filename + Time.now.to_i.to_s), format.downcase )


	  case type
	  when 1
		
	  when 2
        #大图
        resize_b = resize['b'] || 780
        image_mini.combine_options do |img|
          img.resize "#{resize_b}x>"
          img.quality "85"
        end

        result[:width]  = image_mini[:width]
        result[:height]  = image_mini[:height]
		result[:file_name] = n_filename
		result[:file_path] = path_s
        # 生成文件
	    file_path = image_mini.write(File.join(path, n_filename))
	  end

	  # 判断文件是否存在
	  absolute_path = File.join(Rails.root, path, n_filename)
      if File.exist?( absolute_path )
        result[:result] = true
        return  result
      else
        return  { message: '创建失败!', result: false }
      end

    end

	# 保存头像
	def self.save_avatar(file, options={})
	  image_io= open(file)
      #用minimagick读取文件
      image_mini = MiniMagick::Image.read(image_io)

      result = {}
      resize = CONF['image_avatar_format']
	  #判断格式
	  set_format = CONF['verify_img_type']
      format = result[:format] = image_mini[:format]
	  return { message: "只支持JPG、JPEG、PNG、GIF文件", result: false } unless set_format.include?(format)
      #整数转换为字节/ 验证附件大小
      verify_size = (resize['max_size'] || 2).to_i.megabytes
      size = result[:size] = image_mini[:size]
	  return { message: "文件大小不要超过#{resize['max_size']}Mb", result: false } unless verify_size > size

	  # 验证宽高
	  min_w_h = resize['min_w_h']
	  return { message: "图片最低分辨率为#{min_w_h.first}x#{min_w_h.last}", result: false } if min_w_h.first > image_mini[:width] or min_w_h.last > image_mini[:height]
	  # 读取GridFS
	  grid = Mongoid::GridFS
      #大图
      resize_b = resize['o'] || 180
      image_mini.combine_options do |img|
        img.resize "#{resize_b}x>"
        img.quality "100"
      end
      grid_b = grid.put(image_mini.path)
      result[:file_b_id]  = grid_b.id
      result[:file_b_width]  = image_mini[:width]
      result[:file_b_height]  = image_mini[:height]

      if grid_b.present?
        result[:result] = true
        return  result
      else
        return  { message: 'failr', reslut: false }
      end

	end


	#缩略图头像上传,返回图片的mongoid
	def self.save_thumb_avatar(file_id,w,h,x1,y1)

	  # 读取GridFS
	  grid = Mongoid::GridFS

      file = grid.get(file_id)
	  image_mini = MiniMagick::Image.read(file.data)
      resize = CONF['image_avatar_format']
	  image_mini.combine_options do |img|
	    img.quality "100"
	    img.crop "#{w}x#{h}+#{x1}+#{y1}"   
	  end

	  #image_mini.resize Settings.avatar_b
	  image_mini.combine_options do |img|
	    img.resize resize['b']
	    img.quality "100"
	  end
	  id1 = grid.put(image_mini.path)

	  #image_mini.resize Settings.avatar_s
	  image_mini.combine_options do |img|
	    img.resize resize['m']
	    img.quality "100"
	  end
	  id2   = grid.put(image_mini.path)

	  #image_mini.resize Settings.avatar_l
	  image_mini.combine_options do |img|
	    img.resize resize['s']
	    img.quality "100"
	  end
	  id3 = grid.put(image_mini.path)
	  
	  if id1.present? and id2.present? and id3.present?
	    return [ id1.id, id2.id, id3.id,true]
	  else
		return [ 'false', false ]
	  end
	end

  end

  #小方法
  module Mf

	#创建多级目录
	def self.mkdirs(path)
	  if(!File.directory?(path))
		if(!mkdirs(File.dirname(path)))
			return false;
		end
		Dir.mkdir(path)
	  end
	  return true
	end

    #生成文件名
    def self.g_filename( filename , ext )
	  "#{Digest::SHA1.hexdigest(filename)}.#{ext}"
    end

  end

end
