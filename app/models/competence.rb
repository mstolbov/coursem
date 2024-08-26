class Competence < ApplicationRecord
  has_many :course_competences, dependent: :destroy
  has_many :courses, through: :course_competences

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w(name)
  end

  def self.ransackable_associations(auth_object = nil)
    %w()
  end
end
