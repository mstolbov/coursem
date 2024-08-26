class V1::AuthorsController < V1::ApplicationController

  # GET /authors
  def index
    search = Author.ransack(params[:q])
    search.sorts = 'id desc' if search.sorts.empty?
    result = search.result
                   .preload(:courses, :competences)
                   .page(params[:page])
                   .per(params[:size])
    response = {
      collection: result.map { |model| AuthorDetailSerializer.new(model) },
      pagination: pagination(result)
    }
    render json: response
  end

  # GET /authors/1
  def show
    render json: author, serializer: AuthorDetailSerializer
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      render json: @author, serializer: AuthorDetailSerializer, status: :created
    else
      render_unprocessable_entity(@author.errors)
    end
  end

  # PATCH/PUT /authors/1
  def update
    if author.update(author_params)
      render json: author, serializer: AuthorDetailSerializer
    else
      render_unprocessable_entity(@author.errors)
    end
  end

  # DELETE /authors/1
  def destroy
    Coursem::Container["authors.delete_operation"].delete(author)
  end

  private

  def author
    @author ||= Author.find(params[:id])
  end

  def author_params
    params.permit(:name)
  end
end
