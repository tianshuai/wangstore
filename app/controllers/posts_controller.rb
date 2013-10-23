class PostsController < ApplicationController

  before_action do 
	@css_head_post = true
  end

  def index
	@posts = Post.all
  end

  def show
	begin
	  @post = Post.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:notice] = "文章不存在!"
	  render_404
	else
	  if @post.forbid?
	    flash[:notice] = "文章已被禁用!"
	    redirect_to posts_path
	  elsif !@post.published?
	    flash[:notice] = "文章不存在!"
	    render 404
	  else
		#浏览量+1
		Post.increment_counter(:view_count, @post)
	    render 'posts/show'
	  end
	end
  end


end
