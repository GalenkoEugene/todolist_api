class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  rescue_from ActiveRecord::ActiveRecordError, with: :render_exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_exception
  rescue_from ActionController::UnknownController, with: :render_exception
  rescue_from ActionController::RoutingError, with: :render_exception

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def render_exception(error)
    render json: { error: error.message }, status: :not_found
  end
end
