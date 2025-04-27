class ProjectsController < ApplicationController
  def index
    owner = current_user
    @projects = Project.where(owner: owner).order(title: :asc)
    
    render json: @projects
  end
end
