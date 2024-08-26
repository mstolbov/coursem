require 'swagger_helper'

RSpec.describe 'v1/courses', type: :request do

  path '/api/v1/courses' do

    get('List courses') do
      tags 'Courses'
      produces 'application/json'
      description "Return a list of courses."
      parameter name: :q, in: :query, required: false, schema: { '$ref': '#/components/schemas/query_parameter' }, description: "[Search matchers](https://activerecord-hackery.github.io/ransack/getting-started/search-matches/)\n\nAllowed fields to search: `name`, `author_id`, `author_name`, `competences_name`"
      parameter name: :page, in: :query, required: false, schema: { type: :integer, example: 1 }, description: "result page"
      parameter name: :size, in: :query, required: false, schema: { type: :integer, example: 25 }, description: "result size"
      response(200, 'Courses') do
        schema type: :object,
               properties: {
                 collection: { type: :array, items: { '$ref': '#/components/schemas/Course' } },
                 pagination: { '$ref': '#/components/schemas/Pagination' },
               }
        let(:list) { create_list(:course, 3, :with_competences, competences_count: 2) }
        run_test!
      end
    end

    post('Create a new course') do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      description "Create a new course. Parameters:\n\n`name` - The name of a new course.\n\n`author_id` - The author ID of a new course.\n\n`competences_ids` - The list of competences IDs of a new course."
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Course 1" },
          author_id: { type: :integer, format: :int64 },
          competence_ids: { type: :array, items: { type: :integer, format: :int64 } }
        },
        required: %w[name author_id competence_ids]
      }

      response 201, 'A new course created' do
        schema '$ref': '#/components/schemas/Course'
        let(:author) { create :author }
        let(:competences) { create_list :competence, 2 }
        let(:course) { { name: Faker::Educator.course_name, author_id: author.id, competence_ids: competences.map(&:id) } }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:course) { { name: Faker::Educator.course_name, author_id: -100, competence_ids: [-11,-22] } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Competences")
        end
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:competences) { create_list :competence, 2 }
        let(:course) { { name: Faker::Educator.course_name, author_id: -100, competence_ids: competences.map(&:id) } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Author must exist")
        end
      end
    end
  end

  path '/api/v1/courses/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Course ID'

    get('Show a course data') do
      tags 'Courses'
      produces 'application/json'
      description "Return a course data"

      response(200, 'Course data') do
        schema '$ref': '#/components/schemas/Course'
        let(:id) { create(:course, :with_competences, competences_count: 3).id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Course")
        end
      end
    end

    put('Update a course data') do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      description "Update a new course. Parameters:\n\n`name` - The name of a new course.\n\n`author_id` - The author ID of a new course.\n\n`competences_ids` - The list of competences IDs of a new course."
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Course 1" },
          author_id: { type: :integer, format: :int64 },
          competence_ids: { type: :array, items: { type: :integer, format: :int64 } }
        },
        required: %w[name author_id competence_ids]
      }


      response(200, 'Updated course data') do
        schema '$ref': '#/components/schemas/Course'
        let(:id) { create(:course, :with_competences, competences_count: 1).id }
        let(:author) { create :author }
        let(:competences) { create_list :competence, 2 }
        let(:course) { { name: Faker::Educator.course_name, author_id: author.id, competence_ids: competences.map(&:id) } }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        let(:course) { { name: Faker::Educator.course_name, author_id: -100, competence_ids: [-11,-22] } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Course")
        end
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { create(:course, :with_competences, competences_count: 1).id }
        let(:course) { { name: nil, author_id: -100, competence_ids: [-11,-22] } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Competences")
        end
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { create(:course, :with_competences, competences_count: 1).id }
        let(:competences) { create_list :competence, 2 }
        let(:course) { { name: nil, author_id: -100, competence_ids: competences.map(&:id) } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Author must exist")
          expect(data['errors'][1]).to include("Name can't be blank")
        end
      end
    end

    delete('Delete course') do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      description "Delete a new course"

      response(204, 'Course deleted') do
        let(:id) { create(:course, :with_competences, competences_count: 1).id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Course")
        end
      end
    end
  end
end
