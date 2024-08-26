require 'swagger_helper'

RSpec.describe 'v1/competences', type: :request do

  path '/api/v1/competences' do

    get('List competences') do
      tags 'Competences'
      produces 'application/json'
      description "Return a list of competences."
      parameter name: :q, in: :query, required: false, schema: { '$ref': '#/components/schemas/query_parameter' }, description: "[Search matchers](https://activerecord-hackery.github.io/ransack/getting-started/search-matches/)\n\nAllowed fields to search: `name`"
      parameter name: :page, in: :query, required: false, schema: { type: :integer, example: 1 }, description: "result page"
      parameter name: :size, in: :query, required: false, schema: { type: :integer, example: 25 }, description: "result size"
      response(200, 'Competences') do
        schema type: :object,
               properties: {
                 collection: { type: :array, items: { '$ref': '#/components/schemas/Competence' } },
                 pagination: { '$ref': '#/components/schemas/Pagination' },
               }
        let(:list) { create_list(:competence, 3) }
        run_test!
      end
    end

    post('Create a new competence') do
      tags 'Competences'
      consumes 'application/json'
      produces 'application/json'
      description "Create a new competence. Parameters:\n\n`name` - The name of a new competence."
      parameter name: :competence, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Competence 1" }
        },
        required: %w[name]
      }

      response 201, 'A new competence created' do
        schema '$ref': '#/components/schemas/Competence'
        let(:competence) { { name: Faker::Educator.unique.subject } }
        run_test!
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:competence) { { name: nil } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Name can't be blank")
        end
      end
    end
  end

  path '/api/v1/competences/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Competence ID'

    get('Show a competence data') do
      tags 'Competences'
      produces 'application/json'
      description "Return a competence data"

      response(200, 'Competence data') do
        schema '$ref': '#/components/schemas/Competence'
        let(:id) { create(:competence).id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Competence")
        end
      end
    end

    put('Update a competence data') do
      tags 'Competences'
      consumes 'application/json'
      produces 'application/json'
      description "Update a new competence. Parameters:\n\n`name` - The name of a new competence."
      parameter name: :competence, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, default: "Competence 1" }
        },
        required: %w[name author_id competence_ids]
      }


      response(200, 'Updated competence data') do
        schema '$ref': '#/components/schemas/Competence'
        let(:id) { create(:competence).id }
        let(:competence) { { name: Faker::Educator.unique.subject } }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        let(:competence) { { name: Faker::Educator.unique.subject } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Competence")
        end
      end

      response 422, 'Unprocessable Entity' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { create(:competence).id }
        let(:competence) { { name: nil } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Name can't be blank")
        end
      end
    end

    delete('Delete competence') do
      tags 'Competences'
      consumes 'application/json'
      produces 'application/json'
      description "Delete a new competence"

      response(204, 'Competence deleted') do
        let(:id) { create(:competence).id }
        run_test!
      end

      response 404, 'Not Found' do
        schema '$ref': '#/components/schemas/ErrorResponse'
        let(:id) { -100 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors'][0]).to include("Couldn't find Competence")
        end
      end
    end
  end
end
