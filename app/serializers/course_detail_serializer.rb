class CourseDetailSerializer < CourseSerializer
  attributes :id, :name, :created_at, :updated_at

  belongs_to :author, serializer: AuthorSerializer
  has_many :competences, serializer: CompetenceSerializer
end
