class V1::ApplicationController < ::ApplicationController
  rescue_from ActionController::ParameterMissing,
              ActiveRecord::ActiveRecordError,
              with: :render_bad_request

  rescue_from ActionController::RoutingError,
              ActiveRecord::RecordNotFound,
              with: :render_not_found

  protected

  def pagination(result)
    {
      size: result.size,
      page: result.current_page,
      total_pages: result.total_pages,
      total_count: result.total_count
    }
  end

  def render_bad_request(e)
    render json: {
      status: 400,
      error: "Bad Request",
      errors: [ e.message ],
    }, status: :bad_request
  end

  def render_not_found(e)
    render json: {
      status: 404,
      error: "Not Found",
      errors: [ e.message ],
    }, status: :not_found
  end

  def render_unprocessable_entity(errors)
    render json: {
      status: 422,
      error: "Unprocessable Entity",
      errors: errors.full_messages
    }, status: :unprocessable_entity
  end
end
