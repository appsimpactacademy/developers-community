# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  PROFILE_TITLE = [
    'Senior Ruby on Rails Developer',
    'Full Stack Ruby on Rails Developer',
    'Senior Full Stack Ruby on Rails Developer',
    'Junior Full Stack Ruby on Rails Developer',
    'Senior Java Developer',
    'Senior Front End Developer'
  ].freeze

  validates :first_name, :last_name, :username, :profile_title, presence: true
  validates :email, presence: true, uniqueness: true

  scope :with_country, ->(country) { where(country:) }

  has_and_belongs_to_many :groups
  has_many :user_reactions
  has_many :connections, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :articles

  # for repost the post
  has_many :reposts, dependent: :destroy
  has_many :comments, as: :commentable

  # for posts likes
  has_many :likes, dependent: :destroy

  has_one_attached :image
  has_many :skills
  has_many :jobs
  has_many :work_experiences, class_name: 'WorkExperience', dependent: :destroy
  has_many :pages

  has_many :follows
  has_many :pages, through: :follows, source: :followed, source_type: 'Page'

  # for follow & unfollow
  has_many :active_relationships,
           class_name: 'Relationship',
           foreign_key: 'follower_id',
           dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships,
           class_name: 'Relationship',
           foreign_key: 'followed_id',
           dependent: :destroy

  has_many :followers, through: :passive_relationships, source: :follower

  # for sharing the post
  has_many :sent_shares, class_name: 'Share', foreign_key: 'sender_id'
  has_many :received_shares, class_name: 'Share', foreign_key: 'recipient_id'
  has_many :profile_views, foreign_key: 'viewed_user_id'
  has_many :viewers, through: :profile_views, source: :viewer

  has_many :notifications

  def unviewed_notifications_count
    notifications.present? ? notifications.unviewed.count : 0
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(page)
    page.followers.include?(self)
  end

  # for repost the post
  def has_reposted?(post)
    reposts.exists?(post_id: post.id)
  end

  def repost_for(post)
    reposts.find_by(post_id: post.id)
  end

  # for sharing the post
  def shared_posts
    received_shares.map(&:post)
  end

  # for generate the random otp for 6 digit
  attr_accessor :otp_token

  def generate_and_save_otp
    self.otp = SecureRandom.random_number(100_000..999_999).to_s.rjust(6, '0')
    generate_and_save_otp_token # Generate and save the OTP token
    save
  end

  def generate_and_save_otp_token
    self.otp_token = SecureRandom.hex(16)
  end

  def valid_otp?(otp)
    self.otp == otp
  end

  # omniauth login using google
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user ||= User.create(
      email: data['email'],
      profile_title: data['name'],
      password: Devise.friendly_token[0, 20],
      first_name: data['first_name'],
      last_name: data['last_name'],
      username: data['name']
    )
    user
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def address
    return nil if city.blank? && state.blank? && country.blank? && pincode.blank?

    "#{city}, #{state}, #{country}, #{pincode}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[country city]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def my_connection(user)
    Connection.where('(user_id = ? AND connected_user_id = ? ) OR (user_id = ? AND connected_user_id = ? )', user.id,
                     id, id, user.id)
  end

  def check_if_already_connected?(user)
    self != user && !my_connection(user).present?
  end

  def mutually_connected_ids(user)
    connected_user_ids.intersection(user.connected_user_ids)
  end
end
