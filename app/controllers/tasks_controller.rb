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
    result = CreateTask.call(project_id: params[:project_id], name: params[:name], user: current_user)
    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def update
    result = params[:position].present? ? ChangePosition.call(id: params[:id], position: params[:position]) : UpdateTask.call(id: params[:id], params: task_params)

    return render json: result.task, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    task = Task.find_by(id: params[:id])
    return task.destroy if task

    render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found
  end

  def complete
    task = Task.find_by(id: params[:id])
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    task.update(done: !task.done)
    render json: { messages: [I18n.t('messages.all_tasks_complete')] } if all_tasks_complete(task.project.tasks)
  end

  private

  def task_params
    params.permit(:name, :deadline)
  end

  def all_tasks_complete(tasks)
    tasks.each { |t| return false unless t.done }

    true
  end
end
