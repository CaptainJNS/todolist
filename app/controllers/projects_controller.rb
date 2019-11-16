class ProjectsController < ApplicationController
  def index
    render json: { data: Project.where(user: current_user) }, status: :ok
  end

  def show
    project = Project.find_by(user: current_user, id: params[:id])
    return render json: project, status: :ok if project

    render json: { errors: ['Project not found'] }, status: :not_found
  end

  def create
    return render json: { errors: ['The project with such name does already exist.'] }, status: :unprocessable_entity if project_exist?

    project = Project.new(user: current_user, name: params[:name])
    if project.save
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render json: { errors: ['The project with such name does already exist.'] }, status: :unprocessable_entity if project_exist?

    project = Project.find_by(user: current_user, id: params[:id])
    return render json: { errors: ['Project not found'] }, status: :not_found unless project

    if project.update(name: params[:name])
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find_by(user: current_user, id: params[:id])
    return project.destroy if project

    render json: { errors: ['Project not found'] }, status: :not_found
  end

  private

  def project_exist?
    Project.find_by(user: current_user, name: params[:name])
  end
end
