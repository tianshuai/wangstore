# encoding: utf-8
class Admin::ColumnSpacesController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_column_space = true
  end

  #分类列表
  def index
	@css_column_space_list = true
    @column_spaces = ColumnSpace.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @column_space = ColumnSpace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @column_space }
    end
  end

  def edit
    @column_space = ColumnSpace.find(params[:id])
  end


  def create
    @column_space = ColumnSpace.new(params.require(:column_space).permit!)
    if @column_space.save
      redirect_to admin_column_spaces_path, notice: '创建成功!'
    else
      flash[:error] = '创建失败!'
      render 'new'
    end
  end

  def update
    @column_space = ColumnSpace.find(params[:id])

    respond_to do |format|
      if @column_space.update_attributes(params.require(:column_space).permit!)
        format.html { redirect_to admin_column_spaces_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @column_space.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @column_space = ColumnSpace.find(params[:id])
	if @column_space.present?
	  @column_space.destroy
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

  #批量删除
  def destroy_more
	arr = params[:ids]
	arr.split(',').each do |id|
      column_space = ColumnSpace.find(id)
	  if column_space.present?
	    column_space.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #ajax 设置状态
  def ajax_set_state
	@column_space = ColumnSpace.find(params[:id])
	if @column_space.present?
	  @column_space.update_attribute(:state, params[:type])
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

  #私有方法
  private

end
