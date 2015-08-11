FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    password Faker::Internet.password(12)
    sequence(:email) {|n| "awesome_team_email_#{n}@gmail.com" }
  end

  factory :user_1 do
    name Faker::Name.name
    password Faker::Internet.password(12)
    sequence(:email) {|n| "awesome_team_email_#{n}@gmail.com" }
  end

end