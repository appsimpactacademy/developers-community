# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Article', type: :feature do
  describe 'My Article' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to my article path when no article' do
      find('#my-article', wait: 10).click
      article_container = find('#user_article', wait: 10)
      expect(Article.all.count).to eq(0)
      expect(article_container).to have_text('No article is present')
    end

    it 'go to my article path when article exists' do

      article = create(:article, user: user) 

      find('#my-article', wait: 10).click
      article_container = find('#user_article', wait: 10)
      expect(Article.all.count).to eq(1)
      expect(article_container).to_not have_text('No article is present')
      
      visit user_my_articles_path(user)
      article_container = find('#user_article', wait: 10)
      expect(page).to have_text(article.title)
      expect(page).to have_text(article.content)
    end

    it 'should delete the article' do

      article = create(:article, user: user) 

      find('#my-article', wait: 10).click
      article_container = find('#user_article', wait: 10)
      expect(Article.all.count).to eq(1)
      expect(article_container).to_not have_text('No article is present')
      
      visit user_my_articles_path(user)
      article_container = find('#user_article', wait: 10)

      find('#delete_article', wait: 10).click

      # Accept the confirmation alert
      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 2

      expect(page).to have_text('Article was successfully deleted.')
    end
  end
end
