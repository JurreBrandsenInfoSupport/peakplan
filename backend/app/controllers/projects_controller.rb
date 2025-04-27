class ProjectsController < ApplicationController
  def index
    owner = current_user
    @projects = Project.where(owner: owner).order(title: :asc)

    render json: @projects
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      render json: @project, status: :created
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find_by(id: params[:id], owner: current_user)

    if @project
      @project.destroy
      head :no_content
    else
      render json: { errors: [ "Project not found or not owned by you" ] }, status: :not_found
    end
  end

  def update
    @project = Project.find_by(id: params[:id], owner: current_user)

    if @project
      if @project.update(project_params)
        render json: @project
      else
        render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: [ "Project not found or not owned by you" ] }, status: :not_found
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
