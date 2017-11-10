class UpdateTask < Rectify::Command
  def initialize(task, params)
    @task = task
    @params = params
    @project = task.project
  end

  def call
    return broadcast(:ok, task) if updated?
    broadcast(:invalid, task)
  end

  private

  attr_reader :task, :params

  def updated?
    params[:move] ? reorder : task.update(task_params)
  end

  def reorder
    @task.prioritize = true
    case params[:move].to_s
    when 'up' then task.move_higher
    when 'down' then task.move_lower
    else false
    end
  end

  def task_params
    params.require(:task).permit(:id, :name, :deadline, :done)
  end
end
