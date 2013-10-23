# encoding: utf-8
class Admin::BlocksController < Admin::BaseController

  #左侧导航样式
  before_action do
    @css_admin_block = true
  end

  #分类列表
  def index
	@css_block_list = true
    @blocks = Block.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @block = Block.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @block }
    end
  end

  def edit
    @block = Block.find(params[:id])
  end


  def create
    @block = Block.new(params.require(:block).permit!)
    if @block.save
      redirect_to admin_blocks_path, notice: '创建成功!'
    else
      flash[:error] = '创建失败!'
      render 'new'
    end
  end


  def update
    @block = Block.find(params[:id])

    respond_to do |format|
      if @block.update_attributes(params.require(:block).permit!)
        format.html { redirect_to admin_blocks_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @block = Block.find(params[:id])
	if @block.present?
	  @block.destroy
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
      block = Block.find(id)
	  if block.present?
	    block.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #私有方法
  private

end
