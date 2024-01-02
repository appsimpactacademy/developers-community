require 'rails_helper'

RSpec.feature 'Search', type: :feature do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

  before :each do
    sign_in(user)
    visit root_path
  end

  it 'should search for users' do

    find('#search_bar').click

    fill_in 'query', with: 'John Doe'
    
    expect(page).to have_selector('#suggestions', wait: 10)

    # expect(page).to have_css('#search', visible: true, wait: 10)

    expect(page).to have_text('John Doe (User)', wait: 10)
    
    click_link 'John Doe (User)'

    expect(page).to have_text("Profile: #{user.first_name} #{user.last_name}")
  end
end
