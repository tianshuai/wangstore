# encoding: utf-8
module PublicSessionsHelper

  def sign_in(user)
    #permanent:cookie失效日期20年后（永久保存）
    cookies.permanent[:remember_token] = user.remember_token
    #cookies[:remember_token] = { value:   user.remember_token,
    #                        expires: 20.years.from_now.utc }

    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))

    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  #注销
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  #判断是否登录状态
  def signed_in?
    !current_user.nil?
  end

  #不需要执行session,token的controller
  #网络爬虫,是true否false.爬虫没有浏览器
  def request_spidr?
    agent=request.user_agent
    agent='no' if agent.blank?
    agent.match(/(MSIE|Firefox|Chrome|Opera|Safari|Gecko)/).blank?
  end

  #获取当前访问者ip
  def current_ip
    #@env['REMOTE_ADDR'] || ''
    #request.remote_ip || ''
	request.headers['X-Real-IP'] || request.remote_ip
  end

end
