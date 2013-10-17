# encoding: utf-8
require 'open-uri'
namespace :fh do
  desc 'fenghui_api'
  task :fh, [:key, :type] => :environment do |t, args|
	#给参数默认值
	args.with_defaults(key: '', type: 1)
	code = "tui30y100"
	key = args[:key]
	dir = '/opt/fenghui/'
	if key.present?
		puts "参数存在，继续执行……"
		#通过漫画模糊搜索查询漫画ＩＤ
		url = URI.escape("http://open.ifenghui.cn/mobilecms/interface.action?v=2.0&method=comics.get&code=#{code}&keyword=#{key}&fields=id,title,page_total&format=json")
		result = JSON.parse(open(url).read)
		if result['result_total'].to_i >0
		  puts "在锋绘网搜索到此关键字，继续执行……，搜索漫画数量：#{result['result_total']}"
		  result['comics'].each do |d|
			#通过漫画id获取漫画信息
			u = URI.escape("http://open.ifenghui.cn/mobilecms/interface.action?v=2.0&method=comic.get&code=#{code}&comic_id=#{d['id']}&fields=id,title,chapter_count&format=json")
			comic = JSON.parse(open(u).read)
			if comic.present? and comic['comic']['chapter_count'].to_i > 0
			  puts "章节数量#{comic['comic']['chapter_count']}……"
			  title = d['title']
			  num = comic['comic']['chapter_count'].to_i
			  #创建目录，如果目录不存在
			  Dir::mkdir(File.join(dir,title)) unless File.directory?(File.join(dir,title))

			  #通过漫画id获取章节信息
			  u = URI.escape("http://open.ifenghui.cn/mobilecms/interface.action?v=2.0&method=comic.chapters.get&code=#{code}&page_size=#{num}&page_no=1&comic_id=#{d['id']}&fields=id,title,vol,page_total,price,is_free&format=json")
			  chapters = JSON.parse(open(u).read)
			  if chapters.present? and chapters['result_total'].to_i > 0
				chapters['comic_chapters'].each do |e|
				  #获取章节id
				  #章节title
				  c_title = e['title']
				  #如果章节目录不存在则创建
				  Dir::mkdir(File.join(dir,title,c_title)) unless File.directory?(File.join(dir,title,c_title))

				  #通过章节id获得单页地址
				  u = URI.escape("http://open.ifenghui.cn/mobilecms/interface.action?v=2.0&method=comic.details.get&code=#{code}&comic_chapter_ids=#{e['id']}&page_size=#{e['page_total']}&page_no=1&fields=id,img,thumb,img_w,img_h,title,comic_chapter_id&format=json")
				  details = JSON.parse(open(u).read)
				  #如果单页信息存在，则循环处理
				  if details.present? and details['result_total'].to_i > 0
				    puts "图片数量#{details['result_total']}……"
					details['comic_details'].each_with_index do |f,index|
					  next if File.exist?(File.join(dir,title,c_title,"#{c_title}_#{index}.jpg"))
					  data = open(f['img'], 'User-Agent' => 'ruby'){|f| f.read}
					  file = File.new(File.join(dir,title,c_title,"#{c_title}_#{index}.jpg"), 'w+')
					  file.binmode 
					  file << data 
					  file.flush 
					  file.close
				  	  puts "保存图片中 #{index} ..."
					end
				  end
				end
			  end

			end
		  end
		end
	else
	  puts "参数为空!"
	end

  end
end
