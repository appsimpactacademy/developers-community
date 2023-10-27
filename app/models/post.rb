class Post < ApplicationRecord
  belongs_to :user
  belongs_to :page, optional: true

  validates :title, presence: true
  validates :description, presence: true
  #validates :images, presence: true

  scope :hidden_posts, -> { where(hidden: true) }
  scope :with_details, -> { includes(:user, :likes, :reposts, :post_visits, images_attachments: :blob) }
  
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

   # for visiting the post by current user
  has_many :post_visits, dependent: :destroy

  include Notificable

  # for notification
  def user_ids
    User.where(id: user.connected_user_ids).ids
    #User.all.ids
  end

  # for hide & unhide the post
  def hide
    update(hidden: true)
  end

  def unhide
    update(hidden: false)
  end

  # for visiting the post by current user
  def visited_by?(user)
    post_visits.exists?(user: user)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "images_attachment", "image_blob", "user"]
  end
  
end
