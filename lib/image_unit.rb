# encoding: utf-8
module ImageUnit

  class Upload
  
    #保存附件
    #type::1作品图片,／２.编辑器图片；３.栏目块图片
    def self.save_asset(file,type,options={})

	  # 初始化参数
	  user_id = options[:user_id] || 0
	  o_filename = options[:filename] || ''
	  img_kind = options[:img_kind] || ['o']

	  image_io= open(file)

      #用minimagick读取文件
      image_mini = MiniMagick::Image.read(image_io)

      result = {}
	  # 通过ｔｙｐｅ参数查找附件配置要求
      case type
      when 1
		resize = CONF['image_art_format']
      when 2
		resize = CONF['image_editor_format']
	  when 3
		resize = CONF['image_column_format']
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
	  return { message: "文件大小不要超过#{size}Mb", result: false } unless verify_size > size

	  # 验证宽高
	  min_w_h = resize['min_w_h']
	  return { message: "图片最低分辨率为#{min_w_h.first}x#{min_w_h.last}", result: false } if min_w_h.first > image_mini[:width] or min_w_h.last > image_mini[:height]

	  # 获取路径
	  path_root = CONF['asset_path']
	  date_dir = Time.now.year.to_s + ( Time.now.month > 6 ? 'b' : 'a' )
	  path_s = File.join( resize['path'], date_dir)
	  path = File.join(path_root, path_s )
	  #如果目录不存在则创建
	  if(!File.directory?(path))
	    Mf::mkdirs(path)
	    #创建缩略图文件夹
		Dir.mkdir(File.join(path, 'o'))
		Dir.mkdir(File.join(path, 'b'))
		Dir.mkdir(File.join(path, 'm'))
		Dir.mkdir(File.join(path, 's'))
	  end

	  # 生成文件名 
	  n_filename = Mf::g_filename( (user_id.to_s + o_filename + Time.now.to_i.to_s), format.downcase )

      result[:width]  = image_mini[:width]
      result[:height]  = image_mini[:height]

	  result[:file_name] = n_filename
	  result[:file_path] = path_s

	  #生成图片
	  img_kind.each do |i|
		case i
		#原图
		when 'o'
	      # 生成文件
	      file_path = image_mini.write(File.join(path, i, n_filename))		  
		#大图
		when 'b'
          resize_b = resize['b'] || 800
          image_mini.combine_options do |img|
            img.resize "#{resize_b}x>"
            img.quality "85"
          end
          # 生成文件
	      file_path = image_mini.write(File.join(path, i, n_filename))	  
		#中图
		when 'm'
		  resize_m = resize['m'] || [180,150]
		  if (image_mini[:width]-30)<=image_mini[:height]
			image_mini.combine_options do |img|
			  img.resize "#{resize_m[0]}x"
			  img.quality "100"
			  img.gravity "center"
			  img.crop  "#{resize_m[0]}x#{resize_m[1]}+0+0"
			end
		  else
			image_mini.combine_options do |img|
			  img.resize "x#{resize_m[1]}"
			  img.quality "100"
			  img.gravity "center"
			  img.crop  "#{resize_m[0]}x#{resize_m[1]}+0+0"
			end		  
		  end
          # 生成文件
	      file_path = image_mini.write(File.join(path, i, n_filename))	 
		#小图
		when 's'
      	  resize_s = resize['s'] || [50,50]
		  if image_mini[:width]<=image_mini[:height]
			image_mini.combine_options do |img|
			  img.resize "#{resize_s[0]}x"
			  img.quality "100"
			  img.gravity "center"
			  img.crop  "#{resize_s[0]}x#{resize_s[1]}+0+0"
			end
		  else
			image_mini.combine_options do |img|
			  img.resize "x#{resize_s[1]}"
			  img.quality "100"
			  img.gravity "center"
			  img.crop  "#{resize_s[0]}x#{resize_s[1]}+0+0"
			end		  
		  end
          # 生成文件
	      file_path = image_mini.write(File.join(path, i, n_filename))
		end
	  end

	  # 判断文件是否存在
	  absolute_path = File.join(Rails.root, path, img_kind.last, n_filename)
      if File.exist?( absolute_path )
        result[:result] = true
        return  result
      else
        return  { message: '创建失败!', result: false }
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
