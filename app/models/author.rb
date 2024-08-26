class Author < ApplicationRecord
  has_many :courses
  has_many :competences, through: :courses

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w(name)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(competences)
  end
end
