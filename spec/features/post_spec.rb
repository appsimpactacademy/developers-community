# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Post', type: :feature do
  describe 'Post' do
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

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'This is a sample post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')
    end
  end
end
