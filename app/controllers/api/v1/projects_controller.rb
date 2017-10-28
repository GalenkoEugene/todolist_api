class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource through: :current_user

  resource_description do
    short 'Projects'
    error code: 401, desc: 'Unauthorized'
    error code: 422, desc: 'Unprocessable entity'
    formats ['json']
  end

  def_param_group :project do
    param :project, Hash, action_aware: true, required: true do
      param :name, String, required: true
    end
  end

  api :GET, '/projects', "Return user's projects"
  def index
  end

  api :POST, '/projects', 'Create new project'
  param_group :project
  def create
    return render json: @project, status: :created if @project.save
    render json: @project.errors, status: :unprocessable_entity
  end

  api :PUT, '/projects/:id', 'Update project name'
  param_group :project
  param :id, String, required: true
  def update
    return @project, status: :ok if @project.update(project_params)
    render json: @project.errors.full_messages, status: :unprocessable_entity
  end

  api :DELETE, '/projects/:id', 'Desroy certain list'
  param :id, String, required: true
  def destroy
    @project.destroy
    render json: {}, status: :no_content
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
