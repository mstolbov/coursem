module Authors
  class DeleteOperation
    def delete(author)
      new_author = similar_author(author)
      author.courses.update_all(author_id: new_author.id)
      author.destroy!
    end

    private

    def similar_author(author)
      c_ids = author.competences.map(&:id)
      if c_ids.any?
        Author.select(:id)
              .left_joins(courses: [course_competences: [:competence]])
              .where.not(id: author.id)
              .where(competences: { id: c_ids })
              .group(:id)
              .order("count(competences.id) desc")
              .limit(1)
      else
        Author.select(:id).all.limit(1000).first
      end
    end
  end
end