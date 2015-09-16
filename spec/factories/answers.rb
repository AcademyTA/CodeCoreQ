FactoryGirl.define do
  factory :answer do
    # sequence(:title) {|n| "#{n} " + Faker::Company.bs }
    body Faker::Company.bs
    correct true
  end

end