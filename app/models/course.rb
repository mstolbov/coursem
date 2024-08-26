class Course < ApplicationRecord
  belongs_to :author
  has_many :course_competences, dependent: :destroy
  has_many :competences, through: :course_competences

  validates :name, presence: true
  validates :author, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w(name author_id)
  end

  # Allows to search by "author_name_eq" key and so on
  def self.ransackable_associations(auth_object = nil)
    %w(author competences)
  end
end
