class MembersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit_description
    @user = User.find(params[:id])
  end

  def update_description
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(about: params[:user][:about])
        format.turbo_stream { render turbo_stream: turbo_stream.replace('member-description', partial: 'members/member_description', locals: { user: @user }) }
      end
    end
  end
end
