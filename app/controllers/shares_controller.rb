class SharesController < ApplicationController

  def index
    share_post_ids = current_user.shared_posts.map(&:id)
    @shared_posts = Post.preload(:post_visits, :user).where(id: share_post_ids)
  end

  def new
    @share = Share.new
  end

  def create
    @share = Share.new(share_params)
    @share.sender = current_user

    if @share.save
      ShareNotificationMailer.create_notification(@share, current_user.email, current_user.email).deliver_now
      # flash[:success] = "Post shared successfully!"
      redirect_to root_path
    else
      # flash[:error] = "Error sharing post."
      render :new
    end
  end

  private

  def share_params
    params.require(:share).permit(:recipient_id, :post_id)
  end

end
