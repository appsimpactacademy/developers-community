# frozen_string_literal: true

# spec/models/connection_spec.rb

require 'rails_helper'

RSpec.describe Connection, type: :model do
  let(:user) { create(:user) }
  let(:connected_user) { create(:user) }

  it 'is valid with valid attributes' do
    connection = Connection.new(user:, connected_user_id: connected_user.id, status: 'pending')
    expect(connection).to be_valid
  end

  it 'is not valid without a connected_user' do
    connection = Connection.new(user:, status: 'pending')
    expect(connection).to_not be_valid
  end

  it 'is not valid without a status' do
    connection = Connection.new(user:, connected_user_id: connected_user)
    expect(connection).to_not be_valid
  end

  it 'is not valid with an invalid status' do
    connection = Connection.new(user:, connected_user_id: connected_user, status: 'invalid_status')
    expect(connection).to_not be_valid
  end

  it 'is valid with a valid status' do
    connection = Connection.new(user:, requested: connected_user, status: 'accepted')
    expect(connection).to be_valid
  end

  it 'is valid with all possible status values' do
    Connection::CONNECTION_STATUSES.each do |status|
      connection = Connection.new(user:, requested: connected_user, status:)
      expect(connection).to be_valid
    end
  end

  it 'belongs to a user' do
    connection = Connection.new(user:)
    expect(connection.user).to be_a(User)
  end

  it 'belongs to a requested user' do
    connection = Connection.new(requested: user)
    expect(connection.requested).to be_a(User)
  end

  it 'belongs to a received user' do
    connection = Connection.new(received: user)
    expect(connection.received).to be_a(User)
  end

  it 'returns the correct status button class' do
    connection_accepted = Connection.new(status: 'accepted')
    connection_rejected = Connection.new(status: 'rejected')
    connection_other = Connection.new(status: 'pending')

    expect(connection_accepted.status_btn).to eq('btn btn-success')
    expect(connection_rejected.status_btn).to eq('btn btn-danger')
    expect(connection_other.status_btn).to eq('btn btn-primary')
  end
end
