class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  load_resource :project
  load_resource :task, through: :project

  resource_description do
    short '​List of tasks inside a project'
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable entity'
    formats ['json']
  end

  def_param_group :task do
    param :task, Hash, action_aware: true, required: true do
      param :project_id, :number, required: true
      param :name, String, required: true
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
    return render json: @task, status: :ok if @task.update(task_params)
    render json: @task.errors.full_messages, status: :unprocessable_entity
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
