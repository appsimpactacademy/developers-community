# frozen_string_literal: true

class MyArticleController < ApplicationController
  def index
    @articles = current_user.articles.order(created_at: :desc)
  end
end
