class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: @projects = Project.all
  end
end
