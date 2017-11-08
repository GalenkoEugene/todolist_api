class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :task
  load_resource :comment, through: :task

  resource_description do
    short '​List of comments on task'
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable entity'
    error code: 500, desc: 'Internal Server Error'
    formats ['json']
  end

  def_param_group :comment do
    param :project_id, :number, required: true
    param :task_id, :number, required: true
  end

  api :GET, '/projects/:project_id/tasks:task_id/comments', 'List of comments for task'
  param_group :comment
  def index
    render json: @comments
  end

  api :POST, '/projects/:project_id/tasks:task_id/comments', 'Create new comment'
  param :comment, Hash, action_aware: true, required: true do
    param :body, String, required: true
    param :attachment, String, required: false, desc: 'base64 attached image'
  end
  param_group :comment
  def create
    return render json: @comment, status: :created if @comment.save
    render json: @comment.errors, status: :unprocessable_entity
  end

  api :POST, '/projects/:project_id/tasks:task_id/comments/:id', 'Destroy comment by id'
  param :id, :number, required: true
  param_group :comment
  def destroy
    @comment.destroy
    render json: {}, status: :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :attachment)
  end
end
