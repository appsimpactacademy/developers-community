# frozen_string_literal: true

class Page < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :posts
  has_many :jobs

  has_many :follows, as: :followed, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  def followers_count
    followers.count
  end

  ORGANIZATION_TYPE = ['Public company', 'Self-Employeed', 'Gove. Agency', 'Nonprofit', 'Sole Proprietorship',
                       'Private held', 'Partnership'].freeze

  ORGANIZATION_SIZE = ['0-1 employees', '11-50 employees', '51-200 employees', '201-500 employees',
                       '501-1000 employees'].freeze

  INDUSTRY = ['Software Development',
              'Data Security Software Products',
              'Desktop Computing Software Products',
              'Mobile Computing Software Products',
              'Embedded Software Products',
              'IT Service and IT Consulting',
              'IT System Testing and Evaluation',
              'IT System Data Services',
              'IT System Custom Software Development',
              'IT System Training and Support',
              'IT System Installation and Disposal'].freeze
end
