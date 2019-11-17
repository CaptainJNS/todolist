class ProjectsController < ApplicationController
  def index
    render json: Project.where(user: current_user), status: :ok
  end

  def show
    project = Project.find_by(user: current_user, id: params[:id])

    return render json: project, status: :ok if project

    render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found
  end

  def create
    result = CreateProject.call(user: current_user, name: params[:name])

    return render json: result.project, status: :created if result.success?

    render json: { errors: result.errors }, status: :unprocessable_entity
  end

  def update
    result = UpdateProject.call(user: current_user, name: params[:name], id: params[:id])

    return render json: result.project, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    project = Project.find_by(user: current_user, id: params[:id])

    return project.destroy if project

    render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found
  end
end
