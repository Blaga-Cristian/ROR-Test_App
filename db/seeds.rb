User.create!(name: "Example User", 
              email: "normal@gmail.com",
              password: 'password',
              password_confirmation: 'password',
              role: 0,
              activated: true,
              activated_at: Time.zone.now)

User.create!(name: "Example Manager",
              email: "manager@gmail.com",
              password: "password", 
              password_confirmation: "password",
              role: 1,
              activated: true,
              activated_at: Time.zone.now)

User.create!(name: "Example Admin",
              email: "admin@gmail.com", 
              password: "password", 
              password_confirmation: "password",
              role: 2,
              activated: true,
              activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
      email: email,
      password: password,
      password_confirmation: password,
      role: 0,
      activated: true,
      activated_at: Time.zone.now)
end


users = User.order(:created_at).take(6)
50.times do 
  time = rand(30..180)              # time in minutes (e.g., 30 to 180 minutes)
  distance = rand(1000..10000)      # distance in meters (e.g., 1km to 10km)
  date = rand(1..30).days.ago       # random date within the last 30 days

  users.each do |user|
    user.user_entries.create!(
      time: time,
      distance: distance,
      date: date
    )
  end
end
