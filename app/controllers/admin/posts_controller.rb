class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.paginate(:page => params[:page]).order("created_at DESC")
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    @post = Post.find params[:id]
    if @post.update_attributes params.require(:post).permit(:title, :body)
      flash.notice = "Post successfully updated"
      redirect_to admin_posts_path
    else
      flash.alert = @post.errors.full_messages.join(', ')
      render :edit
    end
  end

  def create
    @post = Post.new params.require(:post).permit(:title, :body)
    if @post.save
      flash.notice = "Post successfully created"
      redirect_to admin_posts_path
    else
      flash.alert = @post.errors.full_messages.join(', ')
      render :new
    end
  end

  def destroy
    @post = Post.find params[:id]
    if @post.destroy
      flash.notice = "Post successfully deleted"
      redirect_to admin_posts_path
    else
      flash.alert = "There was an error deleting your post"
    end
  end
end