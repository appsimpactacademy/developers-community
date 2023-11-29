class UserReactionsController < ApplicationController
  before_action :find_post, only: [:create]

  def create
    respond_to do |format|
      build_user_reaction

      destroy_previous_reactions

      if @user_reaction.save
        format.html
        format.js
      end
    end
  end

  private

  def user_reaction_params
    params.require(:user_reaction).permit(:reactable_type, :reactable_id, :user_id)
  end

  def find_post
    @post = Post.includes(:user_reactions).find(params[:post_id])
  end

  def build_user_reaction
    @user_reaction = @post.user_reactions.build(user_reaction_params)
    @user_reaction.user = current_user
    @user_reaction.reaction_type = params[:user_reaction][:reactable_type]
    @user_reaction.reactable = @post
  end

  def destroy_previous_reactions
    previous_reactions = UserReaction.where(user_id: current_user.id, reactable_id: @post.id, reactable_type: "Post")
    previous_reactions.destroy_all
  end

end
