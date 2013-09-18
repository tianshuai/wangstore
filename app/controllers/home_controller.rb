class HomeController < ApplicationController

  def index
	@title = 'home'
  end

  def help

  end

  def about

  end

  def choose
    require 'open-uri'
	code = "tui30y100"
	key = params[:key] || ''
	url = URI.escape("http://open.ifenghui.cn/mobilecms/interface.action?v=2.0&method=comics.get&code=tui30y100&keyword=#{key}&fields=id,title&format=json")

    @result = JSON.parse(open(url).read)

  end

end
