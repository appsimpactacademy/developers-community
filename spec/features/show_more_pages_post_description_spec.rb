# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Show more button for pages about', type: :feature do
  describe 'Show more button for pages about' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the page form and display the validation errors if empty form is submitted' do

      find('#pages', wait: 10).click

      visit pages_path

      find('#add-page-link', wait: 10).click

      expect(page).to have_text('New Page', wait: 10)

      click_button 'Create Page'

      expect(page).to have_text('7 errors prohibited your pages form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Content can't be blank")
      expect(page).to have_text("Industry can't be blank")
      expect(page).to have_text("Website can't be blank")
      expect(page).to have_text("Organization size can't be blank")
      expect(page).to have_text("Organization type can't be blank")
      expect(page).to have_text("About can't be blank")
    end

    it 'should open the page form and save to db if all validation passed' do

      visit pages_path
      
      find('#add-page-link', wait: 10).click
      
      expect(page).to have_text('New Page', wait: 10)

      fill_in 'page_title', with: 'Awesome Page'
      fill_in 'page_website', with: 'https://www.example.com'
      select 'Private', from: 'page_organization_type'
      select '11-50 employees', from: 'page_organization_size'
      select 'Software Development', from: 'page_industry'
      fill_in 'page_content', with: 'Exciting content about the page.'
      fill_in 'page_about', with: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English.'

      click_button 'Create Page'

      visit pages_path
      expect(page).to have_text('Awesome Page')
      expect(page).to have_text('Exciting content about the page.')
      expect(page).to have_text('Software Development')
      expect(page).to have_text('11-50 employees')

      click_link 'Awesome Page'

      find('#pages_post_button', wait: 10).click
    end

    it 'should open the page form and save to db if all validation passed & click the show more button on pages about' do

      visit pages_path
      
      find('#add-page-link', wait: 10).click
      
      expect(page).to have_text('New Page', wait: 10)

      fill_in 'page_title', with: 'Awesome Page'
      fill_in 'page_website', with: 'https://www.example.com'
      select 'Private', from: 'page_organization_type'
      select '11-50 employees', from: 'page_organization_size'
      select 'Software Development', from: 'page_industry'
      fill_in 'page_content', with: 'Exciting content about the page.'
      fill_in 'page_about', with: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English.'

      click_button 'Create Page'

      visit pages_path
      expect(page).to have_text('Awesome Page')
      expect(page).to have_text('Exciting content about the page.')
      expect(page).to have_text('Software Development')
      expect(page).to have_text('11-50 employees')

      click_link 'Awesome Page'

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words whichdont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there ist anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.'
      
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words whichdont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there ist anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.')

      find('.show_more_description').click
    end
  end
end
