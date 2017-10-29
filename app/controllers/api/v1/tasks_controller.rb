class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    short '​List of tasks inside a project'
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable entity'
    formats ['json']
  end

  def_param_group :task do
    param :task, Hash, action_aware: true, required: true do
      param :project_id, String, required: true
      param :name, String, required: true
    end
  end

  api :GET, '/projects/:project_id/tasks', "Return projects's tasks"
  def index
  end

  api :POST, '/projects/:project_id/tasks', 'Create new task'
  param_group :task
  def create
    return render json: @task, status: :created if @task.save
    render json: @task.errors, status: :unprocessable_entity
  end

  private

  def task_params
    params.require(:tasks).permit(:name)
  end
end
