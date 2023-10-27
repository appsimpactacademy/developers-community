# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
ActiveRecord::Base.transaction do 
  10.times do |i|
    user = User.create(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      username: "#{Faker::Name.first_name.downcase}_#{i+10}",
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
    )

    puts "User #{i+1} created successfully."
  end

  100.times do |i|
    user = User.create(
      contact_number: Faker::PhoneNumber.phone_number_with_country_code
      )
    puts "contact_number #{i+1} created successfully"
  end


  job = Job.create(
    title: "Full Stack ROR Developer",
    employee_type: "Full time",
    location: "Indore",
    salary: "10000",
    description: "Full stack ROR developer",
    qualification: "B.E",
    job_category_id: '1'
  )

  job_category = JobCategory.create([
    {name: 'Information Technology (IT)'}, 
    {name: 'Business and Management'},
    {name: 'Sales and Marketing'},
    {name: 'Healthcare'},
    {name: 'Education'},
    {name: 'Finance'},
    {name: 'Engineering'},
    {name: 'Customer Service and Support'},
    {name: 'Government and Public Administration'},
    {name: 'Consulting'},
    {name: 'Entrepreneurship and Startups'},
    {name: 'Retail and Consumer Goods'},
    {name: 'Construction and Real Estate'},
    {name: 'Legal'},
    {name: 'Science and Research'},
    {name: 'Healthcare and Medical'},
    {name: 'Other'}
  ])
end

