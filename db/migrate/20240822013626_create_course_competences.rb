class CreateCourseCompetences < ActiveRecord::Migration[7.2]
  def change
    create_table :course_competences do |t|
      t.references :course, null: false, foreign_key: true
      t.references :competence, null: false, foreign_key: true
      t.index [:course_id, :competence_id], unique: true

      t.timestamps
    end
  end
end
