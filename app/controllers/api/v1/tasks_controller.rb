class Api::V1::TasksController < ApplicationController
  resource_description do
    short I18n.t('docs.tasks.short_description')
    description I18n.t('docs.tasks.long_description')
  end

  def_param_group :task do
    param :name, String, I18n.t('docs.tasks.params.name'), required: true
    param :deadline, DateTime, I18n.t('docs.tasks.params.deadline')
  end

  api :GET, '/tasks/:id', I18n.t('docs.tasks.actions.show')
  param :id, :number, I18n.t('docs.tasks.params.id'), required: true
  def show
    return render json: task, status: :ok if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  api :GET, '/projects/:project_id/tasks', I18n.t('docs.tasks.actions.index')
  param :project_id, :number, I18n.t('docs.tasks.params.project_id'), required: true
  def index
    return render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found unless project

    render json: project.tasks, status: :ok
  end

  api :POST, '/projects/:project_id/tasks/:id', I18n.t('docs.tasks.actions.show')
  param_group :task
  param :project_id, :number, I18n.t('docs.tasks.params.project_id'), required: true
  def create
    result = CreateTask.call(project: project, name: params[:name])
    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :PUT, '/tasks/:id', I18n.t('docs.tasks.actions.update')
  param :id, :number, I18n.t('docs.tasks.params.id'), required: true
  param :position, :number, I18n.t('docs.tasks.params.position')
  param :done, :boolean, I18n.t('docs.tasks.params.done')
  param_group :task
  def update
    result = UpdateTask.call(task: task, params: task_params)
    return render json: result.data, status: :ok if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :DELETE, '/tasks/:id', I18n.t('docs.tasks.actions.destroy')
  param :id, :number, I18n.t('docs.tasks.params.id'), required: true
  def destroy
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    task.destroy
    render json: {}, status: :ok
  end

  private

  def project
    current_user.projects.find_by(id: params[:project_id])
  end

  def task
    current_user.tasks.find_by(id: params[:id])
  end

  def task_params
    params.permit(:name, :deadline, :position, :done)
  end
end
