FactoryGirl.define do
  factory :question do
    sequence(:title) {|n| "#{n} " + Faker::Company.bs }
  end

end
