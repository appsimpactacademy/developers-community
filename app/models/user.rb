class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]


  PROFILE_TITLE = [
    'Senior Ruby on Rails Developer',
    'Full Stack Ruby on Rails Developer',
    'Senior Full Stack Ruby on Rails Developer',
    'Junior Full Stack Ruby on Rails Developer',
    'Senior Java Developer',
    'Senior Front End Developer'
  ].freeze
  
  attr_accessor :otp_token
  has_one_attached :image       

  has_many :work_experiences, dependent: :destroy 
  has_many :connections, dependent: :destroy
  has_many :messages
  has_many :user1_chatrooms, class_name: 'Chatroom', foreign_key: 'user1_id', dependent: :destroy
  has_many :user2_chatrooms, class_name: 'Chatroom', foreign_key: 'user2_id', dependent: :destroy
  has_many :skills

  validates :first_name, :last_name, :profile_title, presence: true
  validates :username, presence: true, uniqueness: true

  def name
    "#{first_name} #{last_name}".strip
  end

  def address
    return nil if city.blank? && state.blank? && country.blank? && pincode.blank?

    "#{city}, #{state}, #{country}, #{pincode}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ['country', 'city']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def my_connection(user)
    Connection.where("(user_id = ? AND connected_user_id = ?) OR (user_id = ? AND connected_user_id = ?)", user.id, id, id, user.id)
  end

  def check_if_already_connected?(user)
    self != user && !my_connection(user).present?
  end

  def mutually_connected_ids(user)
    self.connected_user_ids.intersection(user.connected_user_ids)
  end

  def generate_and_save_otp
    self.otp = SecureRandom.random_number(100000..999999).to_s.rjust(6, '0')
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
    unless user
      user = User.create(
        email: data['email'],
        password: 'password',
        first_name: data['first_name'],
        last_name: data['last_name'],
        username: data['name'],
        profile_title: data['name']
       )
    end
    user
  end
end
