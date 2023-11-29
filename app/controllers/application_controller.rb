# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_query
  before_action :prepare_meta_tags, if: -> { request.get? }

  def set_query
    @query = Post.ransack(params[:q])
  end

  def prepare_meta_tags(options = {})
    site_name   = 'DeveloperCommunity'
    title       = [controller_name, action_name].join(' ')
    description = 'Awesome and Incredible learning platform for Ruby on Rails and Other Web Technology'
    image       = options[:image] || 'your-default-image-url'
    current_url = request.url
    defaults = {
      site: site_name,
      title:,
      image:,
      description:,
      keywords: %w[posting_job post search_user shared_post],
      twitter: {
        site_name:,
        site: '@thecookieshq',
        card: 'summary',
        description:,
        image:
      },
      og: {
        url: current_url,
        site_name:,
        title:,
        image:,
        description:,
        type: 'website'
      }
    }
    options.reverse_merge!(defaults)
    set_meta_tags options
  end

  private

  def render_turbo_stream(action, target, partial = nil, locals = {})
    respond_to do |format|
      format.turbo_stream do
        case action
        when 'replace'
          render turbo_stream: turbo_stream.replace(target, partial:, locals:)
        when 'append'
          render turbo_stream: turbo_stream.append(target, partial:, locals:)
        when 'remove'
          render turbo_stream: turbo_stream.remove(target)
        end
      end
    end
  end
end
