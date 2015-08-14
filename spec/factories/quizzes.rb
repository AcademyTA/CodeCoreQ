FactoryGirl.define do
  factory :quiz do
    sequence(:title) {|n| Faker::Company.bs + "#{n}" }
    body Faker::Lorem.paragraph
    level 10
    category_id 4
  end
end