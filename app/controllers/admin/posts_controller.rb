# encoding: utf-8
class Admin::PostsController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_posts = true
  end

  #分类列表
  def index
    @css_admin_post_list = true
    @posts = Post.article.order_b.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @post = Post.new
    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
	  if @post.present?
        format.html
        #format.json { render json: @post }
	  else
        format.html { redirect_to admin_posts_path, notice: '内容不存在!'}
	  end
	end
  end

  def create
    @post = Post.new(params.require(:post).permit!)
    respond_to do |format|
      if @post.save
        #保存封面图
        if params[:asset_id]
          #获得文件/格式
          file = params[:asset_id]
          file_temp = file.tempfile
          file_name = file.original_filename
          #上传
          result = ImageUnit::Upload.save_asset(file_temp,2)
          if result[:result]
            result[:file_name] = file_name
            result[:relateable_id] = @post.id
            result[:relateable_type] = 'Post'
            hash = collect_asset(result)
            asset = Asset.new(hash)
            if asset.save
              @post.update_attribute(:asset_id, asset.id )
            end
          end
        end
        #保存编辑器图片
        if params[:asset_ids]
          params[:asset_ids].split(',').each do |id|
            asset = Asset.find(id.to_i)
            asset.update_attributes(relateable_id: @post.id, relateable_type: @post.class.to_s) if asset.present?
          end
        end
        format.html { redirect_to admin_posts_path, notice: '创建成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '创建失败!'
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params.require(:post).permit!)
        #保存封面图
        if params[:asset_id]
          #获得文件/格式
          file = params[:asset_id]
          file_temp = file.tempfile
          file_name = file.original_filename
          #上传
          result = ImageUnit::Upload.save_asset(file_temp,2)
          if result[:result]
            result[:file_name] = file_name
            result[:relateable_id] = @post.id
            result[:relateable_type] = 'Post'
            hash = collect_asset(result)
            asset = Asset.new(hash)
            if asset.save
              #删除原有封面图
              @post.cover.destroy if @post.cover.present?
              @post.update_attribute(:asset_id, asset.id )
            end
          end
        end
        format.html { redirect_to admin_posts_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @post = Post.find(params[:id])
	if @post.present?
	  @post.destroy
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
      post = Post.find(id)
	  if post.present?
	    post.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update_attribute(:state, params[:type])
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

  #ajax 设置推荐
  def ajax_set_stick
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update_attribute(:stick, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_stick }
    end
  end

  #ajax 设置发布
  def ajax_set_publish
	@post = Post.find(params[:id])
	if @post.present?
	  @post.update_attribute(:publish, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_publish }
    end
  end


end
