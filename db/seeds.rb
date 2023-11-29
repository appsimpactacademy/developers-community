# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ActiveRecord::Base.transaction do
  # Create dummy users
  User.create!((1..100).map do |i|
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      username: "#{Faker::Name.first_name.downcase} #{i + 10}",
      email: Faker::Internet.email,
      contact_number: Faker::PhoneNumber.phone_number_with_country_code,
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      pincode: Faker::Address.postcode,
      date_of_birth: (Date.today + rand(1..30).days) - rand(24..36).years,
      profile_title: User::PROFILE_TITLE.sample,
      password: 'password',
      about: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
    }
  end)

  # Create dummy articles associated with users
  Article.create!([
    { title: 'First Article', content: 'Content of the first article.', user_id: 1 },
    { title: 'Second Article', content: 'Content of the second article.', user_id: 2 },
    { title: 'Third Article', content: 'Content of the third article.', user_id: 50 }
  ])

  # Create dummy events associated with users
  Event.create!([
    { event_type: 'In Person', event_name: 'Ruby on Rails Basics', start_date: Date.today + 7.days, end_date: Date.today + 8.days, start_time: '09:00 AM', end_time: '05:00 PM', description: 'An introductory workshop on Ruby on Rails basics.', user_id: 1 },
    { event_type: 'Online', event_name: 'Tech Summit 2023', start_date: Date.today + 30.days, end_date: Date.today + 31.days, start_time: '10:00 AM', end_time: '06:00 PM', description: 'A technology summit featuring various sessions and keynotes.', user_id: 2 }
  ])

  # Create dummy groups associated with users
  Group.create!([
    { name: 'Ruby Enthusiasts', description: 'A group for passionate Ruby developers.', industry: 'Technology', location: 'Global', group_type: 'Online', user_id: 1 },
    { name: 'Startup Networking', description: 'Connect with fellow entrepreneurs and share insights.', industry: 'Entrepreneurship', location: 'Various', group_type: 'Offline', user_id: 2 }
  ])

  # Create sample job categories
  JobCategory.create!([
    { name: 'Software Development' },
    { name: 'Marketing' }
  ])



  # Create dummy pages associated with users
  Page.create!([
    { title: 'Tech Solutions Inc.', content: 'Providing innovative tech solutions for businesses.', industry: 'Technology', website: 'https://www.techsolutions.com', organization_size: 'Large', organization_type: 'Corporate', user_id: 1, about: 'We specialize in developing cutting-edge software products.' },
    { title: 'Marketing Agency X', content: 'Full-service marketing agency focusing on digital marketing strategies.', industry: 'Marketing', website: 'https://www.marketingagencyx.com', organization_size: 'Medium', organization_type: 'Agency', user_id: 2, about: 'We help businesses grow through strategic marketing efforts.' }
  ])

  # Create dummy jobs associated with job categories and users
  Job.create!([
    { title: 'Ruby Developer', description: 'Looking for a skilled Ruby developer with experience in Rails.', employee_type: 'Full-time', location: 'Remote', salary: '$80,000 - $100,000', qualification: "Bachelor's degree in Computer Science or related field", status: 'Open', job_category_id: 1, user_id: 1, page_id: 2 },
    { title: 'Marketing Manager', description: 'Seeking an experienced marketing manager for our new campaign.', employee_type: 'Contract', location: 'New York', salary: '$70,000 - $90,000', qualification: '5+ years of marketing experience', status: 'Open', job_category_id: 2, user_id: 2, page_id: 1 }
  ])

  # Create dummy posts associated with users, pages, and groups
  Post.create!([
    { title: 'Introduction to Ruby on Rails', description: 'A beginner-friendly guide to Ruby on Rails.', user_id: 1, hidden: false },
    { title: 'Networking Event Announcement', description: 'Join us for our upcoming networking event!', user_id: 2, hidden: false }
  ])

  # Create dummy skills associated with users
  Skill.create!([
    { title: 'Ruby on Rails', user_id: 2 },
    { title: 'Digital Marketing', user_id: 2 },
    { title: 'JavaScript', user_id: 1 },
    { title: 'Graphic Design', user_id: 1 }
  ])

  # Create dummy work experiences associated with users
  WorkExperience.create!([
    { start_date: Date.new(2018, 5, 1), end_date: Date.new(2021, 8, 31), job_title: 'Software Developer', employment_type: 'Full-time', location: 'San Francisco, CA', location_type: 'On-site', currently_working_here: false, description: 'Developed web applications using Ruby on Rails.', company: 'Tech Solutions Inc.', user_id: 1 },
    { start_date: Date.new(2019, 9, 1), end_date: nil, job_title: 'Marketing Specialist', employment_type: 'Part-time', location: 'New York, NY', location_type: 'Remote', currently_working_here: true, description: 'Managed digital marketing campaigns and social media.', company: 'Marketing Agency X', user_id: 2 }
  ])
end
