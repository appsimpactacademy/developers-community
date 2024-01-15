# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Login With OTP', type: :feature, js: true do
  let(:user) { create(:user) }

  before :each do
    visit root_path
  end

  it 'should enter the wrong otp while login' do

    click_button 'OTP'

    fill_in 'email', with: user.email

    click_link 'Send OTP'

    fill_in 'otp', with: '123456'
    click_button 'Verify OTP'

    expect(page).to have_text('Invalid OTP. Please try again.')
  end

  it 'should visit on login page for login with OTP' do
    click_button 'OTP'

    fill_in 'email', with: user.email

    click_link 'Send OTP'

    fill_in 'otp', with: user.reload.otp
    click_button 'Verify OTP'

    expect(page).to have_text('Signed in successfully.')
  end
end
