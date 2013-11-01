# encoding: utf-8
module ApplicationHelper

  #页面标题
  def page_title(title)
    #base_title = "旺铺，为您精挑细选"
	base_title = "TianShuai,离生活再近一些"
    if title.empty?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end

  #网站meta---art
  def site_meta
	meta_title = @meta_title ||= 'TianShuai,离生活再近一些'
    meta_desc = @meta_desc ||= 'TianShuai,离生活再近一些'
    meta_key = @meta_key ||= 'TianShuai,离生活再近一些'
    meta={
      :title=>meta_title,
      :desc=>meta_desc,
      :key=>meta_key
    }
    return meta
  end

end
