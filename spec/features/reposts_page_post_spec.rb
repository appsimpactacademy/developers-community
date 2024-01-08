require 'rails_helper'

RSpec.feature 'Repost Post', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post', description: 'This is a post by other_user.') }

  before :each do
    sign_in(other_user)
    visit root_path

    find('#pages', wait: 10).click

    visit pages_path
      
    find('#add-page-link', wait: 10).click
    
    expect(page).to have_text('New Page', wait: 10)

    fill_in 'page_title', with: 'Awesome Page'
    fill_in 'page_website', with: 'https://www.example.com'
    select 'Private', from: 'page_organization_type'
    select '11-50 employees', from: 'page_organization_size'
    select 'Software Development', from: 'page_industry'
    fill_in 'page_content', with: 'Exciting content about the page.'
    fill_in 'page_about', with: 'About the awesome page.'

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
    fill_in 'post_description', with: 'This is a sample post description for pages.'
    click_button 'Save Changes'

    page_id = Page.last.id

    visit page_path(page_id)

    expect(page).to have_text('Sample Post for pages')
    expect(page).to have_text('This is a sample post description for pages.')

    find('#add_page_repost', wait: 10).click

    expect(page).to have_text('You cannot repost your own post.')

  end

  it 'should create the user post and repost it' do
    sign_in(current_user)

    visit root_path

    find('#pages', wait: 10).click

    visit pages_path

    expect(page).to have_text('Awesome Page')
    expect(page).to have_text('Exciting content about the page.')
    expect(page).to have_text('Software Development')
    expect(page).to have_text('11-50 employees')

    click_link 'Awesome Page'

    page_id = Page.last.id

    visit page_path(page_id)

    expect(page).to have_text('Sample Post for pages')
    expect(page).to have_text('This is a sample post description for pages.')

    # Repost the other user's post
    click_link 'Repost'

    expect(page).to have_text('Post reposted successfully.') 

    # Remove the repost
    find('#pages', wait: 10).click

    visit pages_path

    expect(page).to have_text('Awesome Page')
    expect(page).to have_text('Exciting content about the page.')
    expect(page).to have_text('Software Development')
    expect(page).to have_text('11-50 employees')

    click_link 'Awesome Page'

    page_id = Page.last.id

    visit page_path(page_id)

    expect(page).to have_text('Sample Post for pages')
    expect(page).to have_text('This is a sample post description for pages.')

    click_link 'Remove Repost'

    expect(page).to_not have_text('Reposted by You')

    expect(page).to have_text('Repost removed')
  end
end
