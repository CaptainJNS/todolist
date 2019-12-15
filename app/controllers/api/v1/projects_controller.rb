class Api::V1::ProjectsController < ApplicationController
  resource_description do
    short I18n.t('docs.projects.short_description')
    description I18n.t('docs.projects.long_description')
  end

  def_param_group :project do
    param :name, String, I18n.t('docs.projects.params.name'), required: true
  end

  api :GET, '/projects', I18n.t('docs.projects.actions.index')
  def index
    render json: current_user.projects, status: :ok
  end

  api :GET, '/projects/:id', I18n.t('docs.projects.actions.show')
  param :id, :number, I18n.t('docs.projects.params.id'), required: true
  def show
    return render json: project, status: :ok if project

    render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found
  end

  api :POST, '/projects', I18n.t('docs.projects.actions.create')
  param_group :project
  def create
    result = CreateProject.call(user: current_user, name: params[:name])
    return render json: result.project, status: :created if result.success?

    render json: { errors: result.errors }, status: :unprocessable_entity
  end

  api :PUT, '/projects/:id', I18n.t('docs.projects.actions.update')
  param :id, :number, I18n.t('docs.projects.params.id'), required: true
  param_group :project
  def update
    result = UpdateProject.call(project: project, name: params[:name])
    return render json: result.project, status: :ok if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :DELETE, '/projects/:id', I18n.t('docs.projects.actions.destroy')
  param :id, :number, I18n.t('docs.projects.params.id'), required: true
  def destroy
    return render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found unless project

    project.destroy
    render json: {}, status: :ok
  end

  private

  def project
    current_user.projects.find_by(id: params[:id])
  end
end
