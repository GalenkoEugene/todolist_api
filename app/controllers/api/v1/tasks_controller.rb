class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  resource_description do
    short '​List of tasks inside a project'
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable entity'
    error code: 500, desc: 'Internal Server Error'
    formats ['json']
  end

  def_param_group :task do
    param :task, Hash, action_aware: true, required: true do
      param :project_id, :number, required: true
      param :name, String, required: true
      param :move, %w[up down], required: false
    end
  end

  api :GET, '/projects/:project_id/tasks', "Return projects's tasks"
  def index
    render json: @tasks
  end

  api :POST, '/projects/:project_id/tasks', 'Create new task'
  param_group :task
  def create
    return render json: @task, status: :created if @task.save
    render json: @task.errors, status: :unprocessable_entity
  end

  api :PUT, '/projects/:project_id/tasks', 'Update task'
  param_group :task
  param :id, :number, required: true
  def update
    UpdateTask.call(@task, params) do
      on(:ok) { render json: @project.tasks, status: :ok }
      on(:invalid) { render json: task.errors.full_messages, status: :unprocessable_entity }
    end
  end

  api :DELETE, '/projects/:project_id/tasks/:id', 'Desroy task by :id'
  param :id, :number, required: true
  def destroy
    @task.destroy
    render json: {}, status: :no_content
  end

  private

  def task_params
    params.require(:task).permit(:name, :deadline, :done)
  end
end
