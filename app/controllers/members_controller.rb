class MembersController < ApplicationController

  def show
    @user = User.includes(image_attachment: :blob).find(params[:id])
    @connections = Connection.where('user_id = ? OR connected_user_id = ?', params[:id], params[:id]).where(status: 'accepted')
    @mutual_connections = current_user.mutually_connected_ids(@user)
  end

  def edit_description; end

  def update_description
    if current_user.update(about: params[:user][:about])
      render_turbo_stream(
        'replace',
        'member-description',
        'members/member_description',
        { user: current_user }
      )
    end
  end

  def edit_personal_details; end

  def update_personal_details
    if current_user.update(user_personal_info_params)
      render_turbo_stream(
        'replace',
        'member-personal-details',
        'members/member_personal_details',
        { user: current_user }
      )
    end
  end

  def connections
    @user = User.find(params[:id])
    total_users = if params[:mutual_connections].present?
                         User.where(id: current_user.mutually_connected_ids(@user))
                       else
                         User.where(id: @user.connected_user_ids)
                       end
    @connected_users = total_users.page(params[:page]).per(10)
    @total_connections = total_users.count
  end

  
  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    redirect_to root_path
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to root_path
  end

  def followers_and_following
    @user = User.find(params[:id])
    @followers = @user.followers.includes([image_attachment: :blob, active_relationships: :follower])
    @following = @user.following.includes(image_attachment: :blob)
  end

  private

  def user_personal_info_params
    params.require(:user).permit(:first_name, :last_name, :city, :state, :country, :pincode, :profile_title)
  end

end
