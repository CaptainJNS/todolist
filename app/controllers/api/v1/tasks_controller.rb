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

    render json: Task.where(project: project), status: :ok
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
  param_group :task
  def update
    result = UpdateTask.call(task: task, params: task_params)
    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :DELETE, '/tasks/:id', I18n.t('docs.tasks.actions.destroy')
  param :id, :number, I18n.t('docs.tasks.params.id'), required: true
  def destroy
    return task.destroy if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  api :POST, '/tasks/:id/complete', I18n.t('docs.tasks.actions.complete')
  param :id, :number, I18n.t('docs.tasks.params.id'), required: true
  def complete
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    task.update(done: !task.done)
    render json: { messages: [I18n.t('messages.all_tasks_complete')] } if all_tasks_complete(task.project.tasks)
  end

  private

  def project
    Project.find_by(id: params[:project_id], user: current_user)
  end

  def task
    Task.find_by(id: params[:id], project: current_user.projects)
  end

  def task_params
    params.permit(:name, :deadline, :position)
  end

  def all_tasks_complete(tasks)
    tasks.each { |t| return false unless t.done }

    true
  end
end
