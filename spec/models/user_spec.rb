# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:connected_user) { create(:user) }
  describe '#association and scops' do
    it 'is valid with valid attributes' do
      user = build(:user) # Use the factory to create a user instance

      expect(user).to be_valid
    end

    it 'is not valid without a first name' do
      user = build(:user, first_name: nil)

      expect(user).not_to be_valid
    end

    it 'is not valid without a last name' do
      user = build(:user, last_name: nil)

      expect(user).not_to be_valid
    end

    it 'is not valid without a username' do
      user = build(:user, username: nil)

      expect(user).not_to be_valid
    end

    it 'is not valid without a profile title' do
      user = build(:user, profile_title: nil)

      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      existing_user = create(:user) # Create a user in the database
      user = build(:user, email: existing_user.email)

      expect(user).not_to be_valid
    end

    it 'is valid with valid attributes' do
      user = create(:user)
      expect(user).to be_valid
    end

    it 'is valid with associated connections' do
      user = create(:user)
      create(:connection, user:, requested: connected_user)
      expect(user).to be_valid
    end

    it 'is valid with associated posts' do
      user = create(:user)
      create(:post, user:)
      expect(user).to be_valid
    end

    it 'is valid with associated events' do
      user = create(:user)
      create(:event, user:)
      expect(user).to be_valid
    end

    it 'is valid with associated reposts' do
      user = create(:user)
      post = create(:post, user:)
      create(:repost, user:, post:)
      expect(user).to be_valid
    end

    it 'is valid with associated comments' do
      user = create(:user)
      create(:comment, commentable: user, user_id: user.id)
      expect(user).to be_valid
    end

    it 'is valid with associated likes' do
      user = create(:user)
      post = create(:post, user:)
      create(:like, user:, post:)
      expect(user).to be_valid
    end

    it 'is valid with an attached image' do
      user = create(:user)
      image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'download.jpeg'), 'image/jpeg')
      user.image.attach(image)
      expect(user).to be_valid
    end

    it 'is valid with associated skills' do
      user = create(:user)
      create(:skill, user:)
      expect(user).to be_valid
    end

    it 'is valid with associated jobs' do
      user = create(:user)
      job_category = create(:job_category)
      create(:job, user:, job_category:)
      expect(user).to be_valid
    end

    it 'is valid with associated work experiences' do
      user = create(:user)
      create(:work_experience, user:)
      expect(user).to be_valid
    end

    it 'is valid with associated pages' do
      user = create(:user)
      create(:page, user:)
      expect(user).to be_valid
    end

    it 'is valid with associated follows' do
      user = create(:user)
      followed_page = create(:page, user:)
      create(:follow, user:, followed: followed_page, followed_type: 'Page')
      expect(user).to be_valid
    end

    it 'is valid with active relationships' do
      user = create(:user)
      followed_user = create(:user)
      create(:relationship, follower: user, followed: followed_user)
      expect(user).to be_valid
    end

    it 'is valid with passive relationships' do
      user = create(:user)
      follower = create(:user)
      create(:relationship, follower:, followed: user)
      expect(user).to be_valid
    end

    it 'is valid with sent shares' do
      user = create(:user)
      post = create(:post, user:)
      create(:share, sender: user, post:)
      expect(user).to be_valid
    end

    it 'is valid with received shares' do
      user = create(:user)
      post = create(:post, user:)
      create(:share, recipient: user, post:)
      expect(user).to be_valid
    end

    it 'is valid with associated notifications' do
      user = create(:user)
      post = create(:post, user:)
      create(:notification, user:, item_type: 'Post', item_id: post.id)
      expect(user).to be_valid
    end

    it 'has a scope with_country' do
      user1 = create(:user, country: 'CountryA')
      user2 = create(:user, country: 'CountryA')
      create(:user, country: 'CountryB')

      expect(User.with_country('CountryA')).to match_array([user1, user2])
    end
  end

  describe '#Methods' do
    it 'unviewed_notifications_count method# returns the count of unviewed notifications' do
      user = create(:user)
      post = create(:post, user:)
      create(:notification, user:, viewed: true, item_type: 'Post', item_id: post.id)
      create(:notification, user:, viewed: false,  item_type: 'Post', item_id: post.id)
      create(:notification, user:, viewed: false,  item_type: 'Post', item_id: post.id)

      expect(user.unviewed_notifications_count).to eq(2)
    end

    it 'returns 0 when there are no unviewed notifications' do
      user = create(:user)
      post = create(:post, user:)
      create(:notification, user:, viewed: true, item_type: 'Post', item_id: post.id)

      expect(user.unviewed_notifications_count).to eq(0)
    end

    it 'follow#creates an active relationship with the specified user' do
      user1 = create(:user)
      user2 = create(:user)

      user1.follow(user2)

      expect(user1.active_relationships.last.followed).to eq(user2)
    end

    it 'unfollow#destroys the active relationship with the specified user' do
      user1 = create(:user)
      user2 = create(:user)

      user1.follow(user2)
      user1.unfollow(user2)

      expect(user1.active_relationships.find_by(followed: user2)).to be_nil
    end

    it 'following?#returns true if the user is following the specified page' do
      user = create(:user)
      page = create(:page, user:)
      user.follows.create(followed: page, followed_type: 'Page')

      expect(user.following?(page)).to be_truthy
    end

    it 'following?#returns false if the user is not following the specified page' do
      user = create(:user)
      page = create(:page, user:)

      expect(user.following?(page)).to be_falsey
    end

    it 'has_reposted?#returns true if the user has reposted the specified post' do
      user = create(:user)
      post = create(:post, user:)
      user.reposts.create(post:)

      expect(user.has_reposted?(post)).to be_truthy
    end

    it 'has_reposted?#returns false if the user has not reposted the specified post' do
      user = create(:user)
      post = create(:post, user:)

      expect(user.has_reposted?(post)).to be_falsey
    end

    it 'repost_for#returns the repost record for the specified post' do
      user = create(:user)
      post = create(:post, user:)
      repost = user.reposts.create(post:)

      expect(user.repost_for(post)).to eq(repost)
    end

    it 'repost_for#returns nil if the user has not reposted the specified post' do
      user = create(:user)
      post = create(:post, user:)

      expect(user.repost_for(post)).to be_nil
    end

    it 'returns an array of posts that the user has received shares for' do
      user = create(:user)
      post1 = create(:post, user:)
      post2 = create(:post, user:)
      user.received_shares.create(post: post1)
      user.received_shares.create(post: post2)

      shared_posts = user.shared_posts

      expect(shared_posts).to include(post1, post2)
    end

    it 'returns an empty array if the user has not received any shares' do
      user = create(:user)

      shared_posts = user.shared_posts

      expect(shared_posts).to be_empty
    end

    it 'generate_and_save_otp#generates and saves a valid OTP' do
      user = create(:user)
      user.generate_and_save_otp

      expect(user.otp).to match(/^\d{6}$/)
    end

    it 'generate_and_save_otp#generates and saves a valid OTP token' do
      user = create(:user)
      user.generate_and_save_otp

      expect(user.otp_token).to be_present
    end

    it 'generate_and_save_otp_token#generates and saves a valid OTP token' do
      user = create(:user)
      user.generate_and_save_otp_token

      expect(user.otp_token).to be_present
    end

    it 'valid_otp#returns true for a valid OTP' do
      user = create(:user, otp: '123456')
      expect(user.valid_otp?('123456')).to be_truthy
    end

    it 'valid_otp#returns false for an invalid OTP' do
      user = create(:user, otp: '123456')
      expect(user.valid_otp?('654321')).to be_falsey
    end

    it 'from_omniauth#creates a new user if the email does not exist' do
      auth_data = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456',
                                         info: { email: 'new_user@example.com', first_name: 'John', last_name: 'Doe', name: 'John Doe' })

      user = User.from_omniauth(auth_data)

      expect(user.email).to eq('new_user@example.com')
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user.username).to eq('John Doe')
    end

    it 'from_omniauth#returns an existing user if the email exists' do
      existing_user = create(:user, email: 'existing@example.com', first_name: 'Jane', last_name: 'Smith',
                                    username: 'Jane Smith')
      auth_data = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456',
                                         info: { email: 'existing@example.com', first_name: 'Jane', last_name: 'Smith', name: 'Jane Smith' })
      user = User.from_omniauth(auth_data)

      expect(user).to eq(existing_user)
      expect(user.first_name).to eq('Jane')
      expect(user.last_name).to eq('Smith')
      expect(user.username).to eq('Jane Smith')
    end

    it 'name#returns the full name of the user' do
      user = create(:user, first_name: 'John', last_name: 'Doe')
      expect(user.name).to eq('John Doe')
    end

    it 'address#returns the formatted address string when all fields are present' do
      user = create(:user, city: 'City', state: 'State', country: 'Country', pincode: '12345')
      expect(user.address).to eq('City, State, Country, 12345')
    end

    it 'address#returns nil when all address fields are blank' do
      user = create(:user, city: nil, state: nil, country: nil, pincode: nil)
      expect(user.address).to be_nil
    end

    it 'address#returns a partial address if some fields are blank' do
      user = create(:user, city: 'City', state: nil, country: 'Country', pincode: nil)
      expect(user.address).to eq('City, , Country, ')
    end

    it 'ransackable_attributes#returns an array of searchable attributes' do
      expect(User.ransackable_attributes).to contain_exactly('country', 'city')
    end

    it 'ransackable_associations#returns an empty array, indicating no searchable associations' do
      ransackable_associations = User.ransackable_associations

      expect(ransackable_associations).to eq([])
    end

    it 'my_connection#returns the connection between the user and specified user' do
      user1 = create(:user)
      user2 = create(:user)
      connection = create(:connection, user: user1, connected_user_id: user2, requested: user2)

      result = user1.my_connection(user2)

      expect(result).to match_array([connection])
    end

    it 'my_connection#returns an empty array when there is no connection between the users' do
      user1 = create(:user)
      user2 = create(:user)

      result = user1.my_connection(user2)

      expect(result).to be_empty
    end

    it 'check_if_already_connected#returns true if the user is not self and is not already connected' do
      user1 = create(:user)
      user2 = create(:user)

      expect(user1.check_if_already_connected?(user2)).to be_truthy
    end

    it 'check_if_already_connected#returns false if the user is self' do
      user1 = create(:user)

      expect(user1.check_if_already_connected?(user1)).to be_falsey
    end

    it 'check_if_already_connected#returns false if the user is already connected' do
      user1 = create(:user)
      user2 = create(:user)
      create(:connection, user: user1, connected_user_id: user2, requested: user2)

      expect(user1.check_if_already_connected?(user2)).to be_falsey
    end

    it 'mutually_connected_ids#returns an array of common connected user IDs' do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)

      create(:connection, user: user1, connected_user_id: user2.id)
      create(:connection, user: user2, connected_user_id: user1.id)
      create(:connection, user: user2, connected_user_id: user3.id)
      create(:connection, user: user1, connected_user_id: user3.id)

      user1.connected_user_ids = [user2.id, user3.id]
      user2.connected_user_ids = [user1.id, user3.id]
      user3.connected_user_ids = [user1.id, user2.id]

      result = user1.mutually_connected_ids(user3)

      expect(result).to contain_exactly(user2.id)
    end
  end
end
