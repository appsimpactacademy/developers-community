class GroupsController < ApplicationController
  before_action :set_groups, only: %i[edit show update destroy follow unfollow followers]

  def index
    @groups = Group.includes(:user).order(created_at: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(group_params)
    if @group.save
      redirect_to groups_path, notice: "Group was created successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def show
    @groups = Group.all
    @group = Group.includes(posts: [{ user: { likes: :user } }, { comments: :user }, { user_reactions: :user }, { images_attachments: :blob }]).find(params[:id])

    # Load associated users for likes and comments
    @users_for_likes = User.where(id: @group.posts.joins(:likes).pluck('likes.user_id').uniq)
    @users_for_comments = User.where(id: @group.posts.joins(:comments).pluck('comments.user_id').uniq)

    @posts = @group.posts
    @post_likes_count = Post.joins(:likes).group('posts.id').count
    comment_counts = Comment.where(commentable_id: @posts.map(&:id), 
                     commentable_type: 'Post')
                     .group(:commentable_id)
                     .count
    @post_comment_counts = comment_counts.transform_keys(&:to_i)
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Group was updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    if @group.destroy
      redirect_to groups_path, alert: "Group was deleted!"
    end
  end

  def follow
    current_user.groups << @group unless current_user.groups.include?(@group)
    redirect_to @group, notice: 'You have followed the group.'
  end

  def unfollow
    current_user.groups.delete(@group) if current_user.groups.include?(@group)
    redirect_to @group, alert: 'You have unfollowed the group.'
  end

  def followers
    @followers = @group.users
  end

  private

  def set_groups
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :industry, :group_type, :location, :user_id, :image)
  end

end
