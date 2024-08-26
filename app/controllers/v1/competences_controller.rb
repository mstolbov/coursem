class V1::CompetencesController < V1::ApplicationController

  # GET /competences
  def index
    search = Competence.ransack(params[:q])
    search.sorts = 'id desc' if search.sorts.empty?
    result = search.result
                   .page(params[:page])
                   .per(params[:size])
    response = {
      collection: result.map { |model| CompetenceSerializer.new(model) },
      pagination: pagination(result)
    }
    render json: response
  end

  # GET /competences/1
  def show
    render json: competence, serializer: CompetenceDetailSerializer
  end

  # POST /competences
  def create
    @competence = Competence.new(competence_params)

    if @competence.save
      render json: @competence, serializer: CompetenceDetailSerializer, status: :created
    else
      render_unprocessable_entity(@competence.errors)
    end
  end

  # PATCH/PUT /competences/1
  def update
    if competence.update(competence_params)
      render json: competence, serializer: CompetenceDetailSerializer
    else
      render_unprocessable_entity(@competence.errors)
    end
  end

  # DELETE /competences/1
  def destroy
    competence.destroy!
  end

  private

  def competence
    @competence ||= Competence.find(params[:id])
  end

  def competence_params
    params.permit(:name)
  end
end
