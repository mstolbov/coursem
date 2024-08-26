FactoryBot.define do
  factory :course do
    name { Faker::Educator.unique.course_name }
    author

    trait :with_competences do
      transient do
        competences_count { 1 }
      end

      after(:create) do |course, evaluator|
        create_list(:course_competence, evaluator.competences_count, course: course)
      end
    end
  end
end
