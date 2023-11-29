# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_page, only: %i[edit update destroy]

  def index
    @pages = Page.includes(:user, :follows, :followers, image_attachment: :blob).order(created_at: :desc)
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(pages_params)
    if @page.save
      redirect_to pages_path
    else
      render :new
    end
  end

  def edit; end

  def show
    @page = Page.includes(posts: [:user, { likes: :user }, { comments: :user }]).find(params[:id])

    # Load associated users for likes and comments
    @users_for_likes = User.where(id: @page.posts.joins(:likes).pluck('likes.user_id').uniq)
    @users_for_comments = User.where(id: @page.posts.joins(:comments).pluck('comments.user_id').uniq)

    @posts = @page.posts
    @post_likes_count = Post.joins(:likes).group('posts.id').count
    comment_counts = Comment.where(commentable_id: @posts.map(&:id),
                                   commentable_type: 'Post')
                            .group(:commentable_id)
                            .count
    @post_comment_counts = comment_counts.transform_keys(&:to_i)
    @jobs = @page.jobs
  end

  def update
    if @page.update(pages_params)
      redirect_to pages_path
    else
      render :edit
    end
  end

  def destroy
    return unless @page.destroy

    redirect_to pages_path
  end

  def follow
    @page = Page.find(params[:id])
    current_user.pages << @page
    respond_to(&:js)
  end

  def unfollow
    @page = Page.find(params[:id])
    current_user.pages.delete(@page)
    respond_to(&:js)
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def pages_params
    params.require(:page).permit(:title, :about, :industry, :website, :organization_size, :organization_type, :user_id,
                                 :content, :image)
  end
end
