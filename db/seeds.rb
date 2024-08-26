# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

authors = (1..10).map { Author.create!(name: Faker::Name.unique.name) }
competences = (1..20).map { Competence.create!(name: Faker::Educator.unique.subject) }

50.times do
  course_competences = (1..rand(1..10)).map { competences.sample }.uniq
  Course.create!(name: Faker::Educator.unique.course_name, author: authors.sample, competences: course_competences)
end
