class CommentsController < ApplicationController
  before_action :set_comments, only: %i[edit destroy]
  before_action :find_commentable, only: [:create, :destroy, :new, :edit, :update, :show]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully created.'
    else
      redirect_to @commentable, alert: 'Error creating comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: 'Comment was successfully deleted.'
  end

  def edit
  end

  def update
    @comment = @commentable.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@commentable), notice: 'Comment was successfully updated.' }
      else
        format.html { redirect_to post_path(@commentable), alert: 'Comment was not updated.' }
      end
    end
  end

  def show
    @comment = @post.comments.build
    render :edit
  end

  private

  def find_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    end
    
    if @commentable.nil?
      redirect_back fallback_location: root_path, alert: 'Commentable not found'
    end
  end

  def set_comments
     @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id)
  end
end
