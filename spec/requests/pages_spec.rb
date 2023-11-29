# frozen_string_literal: true

# spec/requests/pages_controller_spec.rb

require 'rails_helper'

RSpec.describe PagesController, type: :request do
  let(:user) { create(:user) }
  let(:page) { create(:page, user:) }

  describe 'GET /pages' do
    it 'returns a successful response' do
      get '/pages'
      expect(response.status).to eq(302)
    end
  end

  describe 'GET /pages/new' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'returns a successful response' do
        get new_page_path
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get new_page_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /pages' do
    context 'when user is signed in' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new page' do
          expect do
            post pages_path, params: { page: { title: 'Sample page', content: 'Test content', user_id: user.id } }
          end.to change(Page, :count).by(1)

          expect(response).to redirect_to(pages_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new page' do
          expect do
            post pages_path, params: { page: { title: '' } }
          end.not_to change(Page, :count)

          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        post pages_path, params: { page: attributes_for(:page) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /pages/:id' do
    before { sign_in user }
    it 'returns a successful response' do
      get page_path(page)
      expect(response).to be_successful
    end
  end

  describe 'GET /pages/:id/edit' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'returns a successful response' do
        get edit_page_path(page)
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get edit_page_path(page)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /pages/:id' do
    context 'when user is signed in' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the page' do
          patch page_path(page), params: { page: { title: 'Updated Title' } }
          expect(response).to redirect_to(pages_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the page' do
          patch page_path(page), params: { page: { title: '', user_id: nil } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        patch page_path(page), params: { page: { title: 'Updated Title' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /pages/:id' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'destroys the page' do
        page # create the page

        expect do
          delete page_path(page)
        end.to change(Page, :count).by(-1)

        expect(response).to redirect_to(pages_path)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        delete page_path(page)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /pages/:id/follow' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'follows the page', :js do
        post follow_page_path(page), headers: { 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest' }

        expect(response).to be_successful
        expect(user.pages).to include(page)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page', :js do
        post follow_page_path(page)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /pages/:id/unfollow' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'unfollows the page', :js do
        user.pages << page

        delete unfollow_page_path(page), headers: { 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest' }

        expect(response).to be_successful
        expect(user.pages).not_to include(page)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        delete unfollow_page_path(page)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
