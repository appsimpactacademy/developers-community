class RepostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @reposts = Repost.includes(:user, :post)
    post = Post.find(params[:post_id])

    if post.user != current_user
      unless current_user.has_reposted?(post)
        current_user.reposts.create(post: post)
        redirect_to root_path, notice: 'Post reposted successfully.'
      else
        redirect_to root_path, alert: 'You have already reposted this post.'
      end
    else
      redirect_to root_path, alert: 'You cannot repost your own post.'      
    end
    
  end

  def destroy
    repost = current_user.reposts.find(params[:id])
    repost.destroy
    redirect_to root_path, notice: 'Repost removed'
  end

end
