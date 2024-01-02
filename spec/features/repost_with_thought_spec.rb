# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Share the Post', type: :feature do
  describe 'Share the Post' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the post form and display the validation errors if empty form is submitted' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")
    end

    it 'should open the post form and save to db if all validation passed' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post with Lorem Ipsum'
      fill_in 'post_description', with: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'

      click_button 'Save Changes'

      visit root_path

      expect(page).to have_text('Sample Post with Lorem Ipsum')
      expect(page).to have_text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s')

      # repost the post with thought

      find('#repost_with_thought').click
      expect(page).to have_text('Repost with your thought')
      fill_in 'repost_thought', with: 'This is a dummy thought for reposting.'
      
      click_button 'Repost'

      expect(page).to have_text('Post reposted successfully with your thought.')

      expect(page).to have_text('Reposted by You')

      find('#view_repost').click
    end

    it 'should delete the repost with thought post of current user' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post with Lorem Ipsum'
      fill_in 'post_description', with: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'

      click_button 'Save Changes'

      visit root_path

      expect(page).to have_text('Sample Post with Lorem Ipsum')
      expect(page).to have_text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s')

      # repost the post with thought
      find('#repost_with_thought').click

      expect(page).to have_text('Repost with your thought')

      fill_in 'repost_thought', with: 'This is a dummy thought for reposting.'
      
      click_button 'Repost'

      expect(page).to have_text('Post reposted successfully with your thought.')

      expect(page).to have_text('Reposted by You')

      find('#view_repost').click

      find('#delete_repost').click

      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1
      
      expect(page).to have_text('Repost removed')
    end
  end
end
