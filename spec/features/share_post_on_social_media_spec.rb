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

      # share the post on social media

      find('#dropdownMenuButton1').click
      click_link 'facebook_share', wait: 10
    end

    it 'should the share the post on twitter' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post with Lorem Ipsum'
      fill_in 'post_description', with: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'

      click_button 'Save Changes'

      visit root_path

      expect(page).to have_text('Sample Post with Lorem Ipsum')
      expect(page).to have_text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s')

      # Share the post on Twitter
      find('#dropdownMenuButton1').click
      click_link 'twitter_share'
    end
  end
end
