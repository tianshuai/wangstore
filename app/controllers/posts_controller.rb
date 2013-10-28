class PostsController < ApplicationController

  before_action do 
	@css_head_post = true
  end

  def index
	@posts = Post.recent
  end

  def list
	mark = params[:mark] || 'all'
	@category = Category.find_by(mark: mark)
	if @category.present?
	  #根据分类,指定头部样式
	  category_head_show(mark)
	  @posts = @category.posts
	  render 'list'
	else
	  render_404
	end
  end

  def show
	begin
	  @post = Post.find( params[:id], include: { category: [], user: [] } )
	rescue ActiveRecord::RecordNotFound
	  flash[:notice] = "文章不存在!"
	  render_404
	else
	  if @post.forbid?
	    flash[:notice] = "文章已被禁用!"
	    redirect_to posts_path
	  elsif !@post.published?
	    flash[:notice] = "文章不存在!"
	    render_404
	  elsif !@post.category
	    flash[:notice] = "所属分类不存在!"
	    render_404
	  else
		#浏览量+1
		Post.increment_counter(:view_count, @post)
	    #根据分类,指定头部样式
	    category_head_show(@post.category.mark)
	    render 'posts/show'
	  end
	end
  end


end
