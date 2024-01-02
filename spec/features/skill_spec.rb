# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Skills', type: :feature do
  describe 'Skills' do
    describe 'Current user' do
      before :each do
        @user = create(:user)
        sign_in(@user)
        sleep 1
      end

      # it 'should open the skills form and display the validation errors if empty form is submitted' do
      #   visit "/member/#{@user.id}"
      #   expect(page).to have_text('Skills')
      #   find('#add-skill-link', wait: 10).click

      #   sleep 1
      #   expect(page).to have_text('Add your skills')
      #   click_button 'Submit'
      #   sleep 2
      #   expect(page).to have_text('1 error prohibited your skills form being saved.')
      #   expect(page).to have_text("Title can't be blank")
      #   sleep 2
      # end

      it 'should open the skills form and save to db if all validation passed' do
        visit "/member/#{@user.id}"
        expect(page).to have_text('Skills')

        sleep 1
        find('#add-skill-link', wait: 10).click
        sleep 1
        expect(page).to have_text('Add your skills')

        # Add multiple skills here
        fill_in 'skill[title]', with: 'Ruby on Rails'
        sleep 2
        click_button 'Submit'

        fill_in 'skill[title]', with: 'JavaScript'
        sleep 2
        click_button 'Submit'

        fill_in 'skill[title]', with: 'React'
        sleep 2
        click_button 'Submit'

        # After adding skills, you can check if they appear on the user's profile
        visit "/member/#{@user.id}"
        expect(page).to have_text('Ruby on Rails')
        expect(page).to have_text('JavaScript')
        expect(page).to have_text('React')
        sleep 2
      end
    end
  end
end
