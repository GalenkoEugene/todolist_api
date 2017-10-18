class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    short 'Projects'
    error code: 401, desc: 'Unauthorized'
    formats ['json']
  end

  def_param_group :project do
    param :project, Hash, action_aware: true, required: true do
      param :name, String, required: true
    end
  end

  api :GET, '/projects', "Return user's projects"
  def index
    @projects = Project.all
  end
end
