User.create!(name: "Example User", 
              email: "normal@gmail.com",
              password: 'password',
              password_confirmation: 'password',
              role: 0)

User.create!(name: "Example Manager",
              email: "manager@gmail.com",
              password: "password", 
              password_confirmation: "password",
              role: 1)

User.create!(name: "Example Admin",
              email: "admin@gmail.com", 
              password: "password", 
              password_confirmation: "password",
              role: 2)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
      email: email,
      password: password,
      password_confirmation: password,
      role: 0)
end
  
