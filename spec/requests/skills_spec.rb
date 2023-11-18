# spec/requests/skills_controller_spec.rb

require 'rails_helper'

RSpec.describe SkillsController, type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill, user: user) }

  describe 'GET /skills/new' do
    it 'returns a successful response' do
      sign_in user
      get new_skill_path, as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:skill)).to be_a_new(Skill)
    end
  end

  describe 'GET /skills/:id/edit' do
    it 'returns a successful response' do
      sign_in user
      get edit_skill_path(skill), as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:skill)).to eq(skill)
    end
  end

  describe 'POST /skills' do
    context 'with valid parameters' do
      it 'creates a new skill' do
        sign_in user
        skill_params = attributes_for(:skill, user_id: user.id)
        expect {
          post skills_path, params: { skill: skill_params }, as: :turbo_stream
        }.to change(Skill, :count).by(1)
      end

      it 'renders turbo_stream for successful creation' do
        sign_in user
        skill_params = attributes_for(:skill, user_id: user.id)
        post skills_path, params: { skill: skill_params }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end

    context 'with invalid parameters' do
      it 'renders turbo_stream for failed creation' do
        sign_in user
        post skills_path, params: { skill: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end
  end

  describe 'PATCH /skills/:id' do
    context 'with valid parameters' do
      it 'updates the skill' do
        sign_in user
        new_title = 'New Skill'
        patch skill_path(skill), params: { skill: { title: new_title } }, as: :turbo_stream
        skill.reload
        expect(skill.title).to eq(new_title)
      end

      it 'renders turbo_stream for successful update' do
        sign_in user
        patch skill_path(skill), params: { skill: { title: 'New Skill' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end

    context 'with invalid parameters' do
      it 'renders turbo_stream for failed update' do
        sign_in user
        patch skill_path(skill), params: { skill: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end
  end

  describe 'DELETE /skills/:id' do
    it 'deletes the skill' do
      sign_in user
      delete skill_path(skill), as: :turbo_stream
      expect(Skill.exists?(skill.id)).to be_falsey
    end

    it 'renders turbo_stream for successful deletion' do
      sign_in user
      delete skill_path(skill), as: :turbo_stream

      expect(response).to be_successful
      expect(response.body).to include('turbo-stream')
    end
  end
end
