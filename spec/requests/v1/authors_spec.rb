require 'swagger_helper'

RSpec.describe 'v1/authors', type: :request do

  path '/api/v1/authors' do

    get('List authors') do
      tags 'Authors'
      produces 'application/json'
      description "Return a list of authors."
      parameter name: :q, in: :query, required: false, schema: { '$ref': '#/components/schemas/query_parameter' }, description: "[Search matchers](https://activerecord-hackery.github.io/ransack/getting-started/search-matches/)\n\nAllowed fields to search: `name`, `competences_name`"
      parameter name: :page, in: :query, required: false, schema: { type: :integer, example: 1 }, description: "result page"
      parameter name: :size, in: :query, required: false, schema: { type: :integer, example: 25 }, description: "result size"
      response(200, 'Authors') do
        schema type: :object,
               properties: {
                 collection: { type: :array, items: { '$ref': '#/components/schemas/Author' } },
                 pagination: { '$ref': '#/components/schemas/Pagination' },
               }
        let(:list) { create_list(:author, 3, :with_courses, courses_count: 2) }
        run_test!
      end
    end

    post('Create a new author') do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      description "Create a new author. Parameters:\n\n`name` - The name of a new author."
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Author 1" }
        },
        required: %w[name]
      }

      response 201, 'A new author created' do
        schema '$ref': '#/components/schemas/Author'
        let(:author) { { name: Faker::Name.unique.name } }
        run_test!
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:author) { { name: nil } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Name can't be blank")
        end
      end
    end
  end

  path '/api/v1/authors/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Author ID'

    get('Show a author data') do
      tags 'Authors'
      produces 'application/json'
      description "Return a author data"

      response(200, 'Author data') do
        schema '$ref': '#/components/schemas/Author'
        let(:id) { create(:author, :with_courses, courses_count: 3).id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Author")
        end
      end
    end

    put('Update a author data') do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      description "Update a new author. Parameters:\n\n`name` - The name of a new author."
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Author 1" }
        },
        required: %w[name]
      }


      response(200, 'Updated author data') do
        schema '$ref': '#/components/schemas/Author'
        let(:id) { create(:author).id }
        let(:author) { { name: Faker::Name.unique.name } }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        let(:author) { { name: Faker::Name.unique.name } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Author")
        end
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { create(:author).id }
        let(:author) { { name: nil } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Name can't be blank")
        end
      end
    end

    delete('Delete author') do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      description "Delete a new author"

      response(204, 'Author deleted') do
        let(:id) { create_list(:author, 3, :with_courses, courses_count: 3).first.id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Author")
        end
      end
    end
  end
end
