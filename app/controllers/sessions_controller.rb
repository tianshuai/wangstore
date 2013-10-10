# encoding: utf-8
class SessionsController < ApplicationController

  #如果　已登录，则跳到首页
  before_action :forbid_login, only: [ :new, :create ]

  #登录
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user.present? && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in(user)
	  #记录当前ip
	  user.update(ip: current_ip)
	  #记录最后登录时间
	  user.update(last_time: Time.now)
      redirect_back_or(user)
    else
      flash.now[:error] = '无效的用户名或密码' # Not quite right!
      render 'new'
    end
  end

  #注销
  def destroy
    sign_out
    flash[:success] = '成功退出!'
    redirect_to root_path
  end

end
