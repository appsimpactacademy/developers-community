# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  # validates :images, presence: true

  scope :hidden_posts, -> { where(hidden: true) }
  scope :with_details, -> { includes(:user, :likes, :reposts, images_attachments: :blob) }

  # for user reactions
  has_many :user_reactions, as: :reactable

  has_many_attached :images
  has_many :hidden_posts
  # for repost the post
  has_many :reposts, dependent: :destroy
  has_many :comments, as: :commentable
  # for sharing the post
  has_many :shares, dependent: :destroy
  # for posts likes
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  belongs_to :user
  belongs_to :page, optional: true
  belongs_to :group, optional: true

  include Notificable

  # for notification
  def user_ids
    User.where(id: user.connected_user_ids).ids
    # User.all.ids
  end

  # for hide & unhide the post
  def hide
    update(hidden: true)
  end

  def unhide
    update(hidden: false)
  end

  def user_reactions_count(reaction_type)
    user_reactions.where(reaction_type:).count
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[comments images_attachment image_blob user]
  end
end
