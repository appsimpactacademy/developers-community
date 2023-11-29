class Group < ApplicationRecord
  belongs_to :user
  
  has_and_belongs_to_many :users
  has_many :posts
  has_one_attached :image

  INDUSTRY = [  'Software Development',
                'Data Security Software Products',
                'Desktop Computing Software Products',
                'Mobile Computing Software Products',
                'Embedded Software Products',
                'IT Service and IT Consulting',
                'IT System Testing and Evaluation',
                'IT System Data Services',
                'IT System Custom Software Development',
                'IT System Training and Support',
                'IT System Installation and Disposal'
              ]
              
  GROUP_TYPE = ['Public', 'Private']
end
