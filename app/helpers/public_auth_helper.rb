# encoding: utf-8
##权限的helper方法
module PublicAuthHelper

  #是否普通用户
  def default?
    return false if current_user.blank?
    return true if current_user.role_id == User::ROLE_ID[:user]
    return false
  end
  
  #是否管理员
  def admin?
    return false if current_user.blank?      
	#用户已禁用?
	return false if current_user.forbid?
    return true if current_user.role_id == User::ROLE_ID[:admin]
    return false
  end
  #是否超级用户
  def system?
    return false if current_user.blank?      
	#用户已禁用?
	return false if current_user.forbid?
    return true if current_user.role_id == User::ROLE_ID[:system]
    return false      
  end
  #是否编辑
  def editor?
    return false if current_user.blank?
	#用户已禁用?
	return false if current_user.forbid?
    return true if current_user.role_id == User::ROLE_ID[:editor]
    return true if admin?
    return true if system?
    return false
  end

  
  #是否超级用户或管理员
  def admin_system?
    return false if current_user.blank?
	#用户已禁用?
	return false if current_user.forbid?
    return true if admin?
    return true if system?    
    return false 
  end
  
  #通过ＩＤ判断是否是当前用户
  def owner?(user_id)
    return false if user_id.blank?
    return false if current_user.blank?
    return true if user_id.to_i == current_user.id
    return false

  end

  #如果未登录，跳到登录页面
  def signed_in_user
	unless signed_in?
	  store_location
      redirect_to signin_path, notice: "请先登录"
	else
	  redirect_to root_path, notice: '账户被冻结,请与管理员联系...' if current_user.forbid? 
	end

  end

  #如果　已登录，则跳到首页
  def forbid_login
    redirect_to root_path, notice: "已登录" if signed_in?
  end

  #跳转相应页面并删除session[:return_to]
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #跳转到：如登录页面前记录链接地址
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  #管理员权限
  def authenticate_admin
    unless admin_system?
      flash[:notice] ="您没有访问权限!"
      redirect_to domain_base
	end
  end

	#可信用户，管理员，编辑，Owner 可以
	def can_edit?(item)
	  return false if item.blank?
	  return false if current_user.blank?
	  return true if owner?(item.id)
	  return true if editor?
	  return true if admin?
	  return true if system?
	  false
	end


end


