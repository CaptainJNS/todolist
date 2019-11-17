class TasksController < ApplicationController
  def show
    task = Task.find_by(id: params[:id])
    return render json: task, status: :ok if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  def index
    project = Project.find_by(user: current_user, id: params[:project_id])
    return render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found unless project

    render json: Task.where(project: project), status: :ok
  end

  def create
    project = Project.find_by(user: current_user, id: params[:project_id])
    return render json: { errors: [I18n.t('errors.project_not_found')] }, status: :not_found unless project

    task = Task.new(project: project, name: params[:name])
    return render json: task, status: :created if task.save

    render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    result = UpdateTask.call(id: params[:id], params: task_params)

    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    task = Task.find_by(id: params[:id])

    return task.destroy if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  private

  def task_params
    params.permit(:name, :deadline)
  end
end
