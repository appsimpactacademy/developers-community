class SkillsController < ApplicationController
  before_action :set_skill, only: %i[edit update destroy]

  def new
    @skill = current_user.skills.new
  end

  def edit
  end

  def create
    @skill = current_user.skills.new(skill_params)
    if @skill.save
      render_turbo_stream(
        'append',
        'skill_items',
        'skills/skill',
        {skill: @skill }
        )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'skills/form', 
          modal_title: 'Add New Skills' 
        }
        )
    end
  end

  def destroy
    @skill.destroy
    render_turbo_stream(
      'remove',
      "skill_item_#{@skill.id}",
      )
  end

  def update
    if @skill.update(skill_params)
      render_turbo_stream(
        'replace',
        "skill_item_#{@skill.id}",
        'skills/skill',
        {skill: @skill }
        )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'skills/form', 
          modal_title: 'Edit Skills' 
        }
        )
    end
  end


  private

  def set_skill
    @skill = current_user.skills.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:title)
  end
end
