# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Articles', type: :feature do
  describe 'Articles' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the article form and display the validation errors if empty form is submitted' do

      find('#add-article-link', wait: 10).click
      expect(page).to have_text('Write Article', wait: 10)

      click_button 'Submit'

      expect(page).to have_text('2 errors prohibited your articles form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Content can't be blank")
    end

    it 'should open the article form and save to db if all validation passed' do
      
      find('#add-article-link', wait: 10).click
      
      expect(page).to have_text('Write Article', wait: 10)

      fill_in 'article_title', with: 'Sample Article'
      fill_in 'article_content', with: 'This is a sample article content.'

      click_button 'Submit'

      visit articles_path
      expect(page).to have_text('Sample Article')
      expect(page).to have_text('This is a sample article content.')

      find('#view_article', wait: 10).click
    end

    it 'should edit the article' do
      find('#add-article-link', wait: 10).click
      
      expect(page).to have_text('Write Article', wait: 10)

      fill_in 'article_title', with: 'Sample Article'
      fill_in 'article_content', with: 'This is a sample article content.'

      click_button 'Submit'

      visit articles_path
      expect(page).to have_text('Sample Article')
      expect(page).to have_text('This is a sample article content.')

      find('#view_article', wait: 10).click


      find('#edit_article', wait: 10).click

      expect(page).to have_text('Edit Article', wait: 10)

      fill_in 'article_title', with: 'Dummy Article'
      fill_in 'article_content', with: 'This is a Dummy Article Content.'

      click_button 'Submit'
    end

    it 'should delete the article' do

      find('#add-article-link', wait: 10).click
      
      expect(page).to have_text('Write Article', wait: 10)

      fill_in 'article_title', with: 'Sample Article'
      fill_in 'article_content', with: 'This is a sample article content.'

      click_button 'Submit'

      visit articles_path
      expect(page).to have_text('Sample Article')
      expect(page).to have_text('This is a sample article content.')

      find('#view_article', wait: 10).click

      find('#delete_article', wait: 10).click

      # Accept the confirmation alert
      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1

      visit articles_path
      expect(page).to have_text('No articles are present.')
    end
  end
end
