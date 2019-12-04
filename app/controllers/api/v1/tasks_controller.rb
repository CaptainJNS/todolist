class Api::V1::TasksController < ApplicationController
  def show
    return render json: task, status: :ok if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  def index
    return render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found unless project

    render json: Task.where(project: project), status: :ok
  end

  def create
    result = CreateTask.call(project: project, name: params[:name])
    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def update
    result = UpdateTask.call(task: task, params: task_params)
    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    return task.destroy if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

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
    Task.find_by(id: params[:id], project: project)
  end

  def task_params
    params.permit(:name, :deadline, :position)
  end

  def all_tasks_complete(tasks)
    tasks.each { |t| return false unless t.done }

    true
  end
end
