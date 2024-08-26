class V1::CoursesController < V1::ApplicationController

  # GET /courses
  def index
    search = Course.ransack(params[:q])
    search.sorts = 'id desc' if search.sorts.empty?
    result = search.result
                   .preload(:author, :course_competences, :competences)
                   .page(params[:page])
                   .per(params[:size])
    response = {
      collection: result.map { |model| CourseDetailSerializer.new(model) },
      pagination: pagination(result)
    }
    render json: response
  end

  # GET /courses/1
  def show
    render json: course, serializer: CourseDetailSerializer
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      render json: @course, serializer: CourseDetailSerializer, status: :created
    else
      render_unprocessable_entity(@course.errors)
    end
  end

  # PATCH/PUT /courses/1
  def update
    if course.update(course_params)
      render json: course, serializer: CourseDetailSerializer
    else
      render_unprocessable_entity(course.errors)
    end
  end

  # DELETE /courses/1
  def destroy
    course.destroy!
  end

  private

  def course
    @course ||= Course.find(params[:id])
  end

  def course_params
    params.permit(:name, :author_id, competence_ids: [])
  end
end
