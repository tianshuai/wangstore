# encoding: utf-8
module ApplicationHelper

  #页面标题
  def page_title(title)
    base_title = "旺铺，为您精挑细选"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end

end
