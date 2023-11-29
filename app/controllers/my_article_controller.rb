class MyArticleController < ApplicationController
  
  def index
    @articles = current_user.articles.order(created_at: :desc)
  end
  
end
