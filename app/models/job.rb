# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :job_category
  belongs_to :user
  belongs_to :page, optional: true

  EMPLOYEE_TYPE = %w[Full-time Part-time Self-Employeed Freelance Trainee Internship].freeze

  STATUS = %w[Public Private Archieved].freeze

  SALARY = [
    '₹ 5000-10000',
    '₹ 10000-15000',
    '₹ 15000-20000',
    '₹ 20000-25000',
    '₹ 25000-30000'
  ].freeze

  QUALIFICATION = ['Graduation', 'Post Graduation', '12th Standard'].freeze

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description employee_type id job_category_id location qualification salary
       status title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[job_category user]
  end
end
