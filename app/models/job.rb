class Job < ApplicationRecord
  belongs_to :job_category
  belongs_to :user
  belongs_to :page

  EMPLOYEE_TYPE = ['Full-time', 'Part-time', 'Self-Employeed', 'Freelance', 'Trainee', 'Internship']

  STATUS = [ 'Public', 'Private', 'Archieved' ]

  SALARY = [
    '₹ 5000-10000',
    '₹ 10000-15000',
    '₹ 15000-20000',
    '₹ 20000-25000',
    '₹ 25000-30000'
  ]

  QUALIFICATION = [ 'Graduation', 'Post Graduation', '12th Standard' ]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "employee_type", "id", "job_category_id", "location", "qualification", "salary", "status", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["job_category", "user"]
  end

end
