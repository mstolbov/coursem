class CompetenceDetailSerializer < CompetenceSerializer
  attributes :id, :name

  has_many :courses, serializer: CourseSerializer
end
