FactoryGirl.define do
  factory :question do
    sequence(:title) {|n| "#{n} " + Faker::Company.bs }
    body Faker::Company.bs
    explanation Faker::Company.bs
  end

end
