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

  def show
    @repost = Repost.includes(post: [:user]).find(params[:id])
    @user_reposts = @repost.post.reposts
  end

  def destroy
    @repost = Repost.find(params[:id])
    @repost.destroy
    redirect_to root_path, notice: 'Repost removed successfully.'
  end
  

  def repost_with_thought
    post = Post.find(params[:id])
    thought = params[:repost][:thought] # Assuming 'thought' is sent through the params
    if current_user.has_reposted?(post)
      redirect_to root_path, alert: 'You have already reposted this post.'
    else
      current_user.reposts.create(post: post, thought: thought)
      redirect_to root_path, notice: 'Post reposted successfully with your thought.'
    end
  end

  def destroy
    repost = current_user.reposts.find(params[:id])
    repost.destroy
    redirect_to root_path, notice: 'Repost removed'
  end

end
