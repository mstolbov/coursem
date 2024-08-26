class AuthorDetailSerializer < AuthorSerializer
  attributes :id, :name

  has_many :courses, serializer: CourseSerializer
  has_many :competences, serializer: CompetenceSerializer
end
