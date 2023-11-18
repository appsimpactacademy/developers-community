class PostsController < ApplicationController
  before_action :set_post, only: %i[edit show update destroy]
  
  def index
    @original_posts = current_user.posts.includes(:user, :likes, :reposts, :post_visits, images_attachments: :blob)
   @reposted_posts = current_user.reposts.includes(post: [:user, :comments, :likes, :post_visits, images_attachments: :blob]).map(&:post)

   @posts = (@original_posts + @reposted_posts).uniq.sort_by(&:created_at).reverse

   @post_likes_count = Post.joins(:likes).group('posts.id').count

   comment_counts = Comment.where(commentable_id: @posts.map(&:id), 
    commentable_type: 'Post').group(:commentable_id).count

    # Now, you can create a hash where keys are post IDs and values are comment counts
    @post_comment_counts = comment_counts.transform_keys(&:to_i)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = @post.user
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    
      # # for visiting the post by current user
      PostVisit.create(user: current_user, post: @post)

      prepare_meta_tags(
        title: @post.title,
        description: @post.description,
        twitter: {
          card: @post.title
        },
        og: {
          url: post_path(@post),
          title: @post.title,
          # image: (ENV['APP_URL'] + rails_blob_path(@post.images)),
          description: @post.description,
        }
        )
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path
    end
  end

  # for hide & unhide the post
  def hide
    @post = Post.find(params[:id])
    @post.update(hidden: true)
    redirect_to root_path, notice: 'Post is hidden'
  end

  def undo_hide
    @post = Post.find(params[:id])
    @post.update(hidden: false)
    redirect_to root_path, notice: 'Post is unhidden'
  end

  def toggle_hide
    @post = Post.find(params[:id])
    @post.update(hidden: !@post.hidden)

    respond_to do |format|
      format.json { render json: { hidden: @post.hidden } }
    end
  end

  def hidden
    @hidden_posts = Post.hidden_posts
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :user_id, :page_id, images: [])
  end

end
