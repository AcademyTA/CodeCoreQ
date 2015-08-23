FactoryGirl.define do
  factory :category do
    sequence(:title) {|n| "#{n}" + Faker::Company.bs }
  end
end
