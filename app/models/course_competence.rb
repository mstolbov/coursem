class CourseCompetence < ApplicationRecord
  belongs_to :course, required: true
  belongs_to :competence, required: true

  validates :competence, uniqueness: { scope: :course }
end
