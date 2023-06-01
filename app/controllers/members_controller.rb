class MembersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit_description update_description]

  def show
    @user = User.find(params[:id])
  end

  def edit_description; end

  def update_description
    respond_to do |format|
      if current_user.update(about: params[:user][:about])
        format.turbo_stream { render turbo_stream: turbo_stream.replace('member-description', partial: 'members/member_description', locals: { user: current_user }) }
      end
    end
  end
end
