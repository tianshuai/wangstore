# encoding: utf-8
class Admin::ColumnsController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_column = true
  end

  #分类列表
  def index
	@css_column_list = true
    @columns = Column.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @column = Column.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @column }
    end
  end

  def edit
    @column = Column.find(params[:id])
  end


  def create
    @column = Column.new(params.require(:column).permit!)
    if @column.save
      if params[:asset_id]
        #获得文件/格式
		file = params[:asset_id]
        file_temp = file.tempfile
		file_name = file.original_filename
		user_id = params[:user_id].to_i
        #上传
        result = ImageUnit::Upload.save_asset(file_temp,3, { user_id: user_id, filename: file_name, img_kind: ['o','s'] })
		if result[:result]
          result[:name] = file_name
          result[:relateable_id] = @column.id
          result[:relateable_type] = 'Column'
	  	  result[:kind] = 2
          hash = collect_asset(result)
          asset = Asset.create(hash)
		end
      end
      redirect_to admin_columns_path, notice: '创建成功!'
    else
      flash[:error] = '创建失败!'
      render 'new'
    end
  end


  def update
    @column = Column.find(params[:id])

    respond_to do |format|
      if @column.update_attributes(params.require(:column).permit!)
		  if params[:asset_id]
			#获得文件/格式
			file = params[:asset_id]
			file_temp = file.tempfile
			file_name = file.original_filename
			user_id = params[:user_id].to_i
			#上传
			result = ImageUnit::Upload.save_asset(file_temp,3, { user_id: user_id, filename: file_name, img_kind: ['o','s'] })
			if result[:result]
			  result[:name] = file_name
			  result[:relateable_id] = @column.id
			  result[:relateable_type] = 'Column'
	  	  	  result[:kind] = 2
			  hash = collect_asset(result)
			  asset = Asset.create(hash)
			end
		  end
        format.html { redirect_to admin_columns_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @column.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @column = Column.find(params[:id])
	if @column.present?
	  @column.destroy
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
      column = Column.find(id)
	  if column.present?
	    column.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #ajax 设置状态
  def ajax_set_state
	@column = Column.find(params[:id])
	if @column.present?
	  @column.update_attribute(:state, params[:type])
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
