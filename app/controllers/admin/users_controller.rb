# encoding: utf-8
class Admin::UsersController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_user = true
  end

  def index
	@css_user_list = true
    @users = User.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  def destroy
    @user = User.find(params[:id].to_i)
	if @user.present?
	  @user.destroy
	  @success = true
	  @notice = "删除成功!"
    else
	  @success = false
	  @notice = ' 删除失败!'
	end

    respond_to do |format|
      format.html
      format.js { render :destroy }
    end
  end

  #ajax 设置状态
  def ajax_set_state
	@user = User.find(params[:id].to_i)
	if @user.present?
	  @user.update_attribute(:state, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_state }
    end
  end

  #批量设置权限
  def ajax_set_role
	if system?
	  arr = params[:ids]
	  role_id = params[:role_id] || 1
	  arr.split(',').each do |id|
		@user = User.find(id.to_i)
		@user.update_attribute(:role_id, role_id) if @user.present?
	  end
	  @success = true
	  @note = "设置成功"
	else
	  @success = false
	  @note = "没有权限"
	end

    respond_to do |f|
      f.html
      f.js { render :ajax_set_role }
    end
  end

end
