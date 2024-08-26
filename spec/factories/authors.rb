FactoryBot.define do
  factory :author do
    name { Faker::Name.unique.name }

    trait :with_courses do
      transient do
        courses_count { 1 }
      end

      after(:create) do |author, evaluator|
        create_list(:course, evaluator.courses_count, author: author)
      end
    end
  end
end
