class SearchController < ApplicationController
  def suggestions
    @results = search_results

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
            turbo_stream.update('suggestions',
                                partial: 'search/suggestions',
                                locals: { results: @results })
      end
    end
  end

  def results
    @user = User.includes(following: { posts: [:comments, :likes] }, posts: [:comments, :likes], image_attachment: :blob).find(params[:user_id])
    @posts = @user.posts
    @mutual_connections = current_user.mutually_connected_ids(@user)
    @post_likes_count = @posts.joins(:likes).group('posts.id').count

    comment_counts = Comment.where(commentable_id: @posts.map(&:id), commentable_type: 'Post')
                           .group(:commentable_id)
                           .count
    @post_comment_counts = comment_counts.transform_keys(&:to_i)
    @people_i_follow_count = @user.following.size
  end



  private

  def search_results
    query = params[:query]
    User.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%") +
    Post.where("title ILIKE ?", "%#{query}%") + 
    Job.where("title ILIKE ?", "%#{query}%") + 
    Event.where("event_name ILIKE ?", "%#{query}%") + 
    Page.where("title ILIKE ? OR content ILIKE ?", "%#{query}%", "%#{query}%")
  end
end
