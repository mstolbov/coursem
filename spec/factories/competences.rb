FactoryBot.define do
  factory :competence do
    name { Faker::Educator.unique.subject }
  end
end
