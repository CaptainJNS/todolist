class Api::V1::CommentsController < ApplicationController
  def index
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    render json: Comment.where(task: task), status: :ok
  end

  def create
    result = CreateComment.call(params: comment_params.merge(task: task))
    return render json: result.comment, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    return comment.destroy if comment

    render json: { errors: [I18n.t('errors.comment_not_found')] }, status: :not_found
  end

  private

  def project
    Project.find_by(id: params[:project_id], user: current_user)
  end

  def task
    Task.find_by(id: params[:task_id], project: project)
  end

  def comment
    Comment.find_by(id: params[:id], task: task)
  end

  def comment_params
    params.permit(:body, :image)
  end
end
