# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Hidden Post', type: :feature do
  describe 'Hidden Post' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the post form and display the validation errors if empty form is submitted and hide the post' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")
    end

    it 'should open the post form of current user and save to db if all validation passed and hide the post' do
      
      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'This is a sample post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')

      find("#hidden_post").click

      expect(page).to have_text('Post is hidden')

      visit hidden_posts_path

      expect(page).to have_text('Hidden Posts')
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')

      find('#undo_hidden_post').click
      expect(page).to have_text('Post is unhidden')

      visit root_path
    end
  end
end
