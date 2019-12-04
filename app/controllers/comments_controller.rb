class CommentsController < ApplicationController
  def index
    task = Task.find_by(id: params[:task_id])
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    render json: Comment.where(task: task), status: :ok
  end

  def create
    result = CreateComment.call(task_id: params[:task_id], body: params[:body], image: params[:image])
    return render json: result.comment, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    return comment.destroy if comment

    render json: { errors: [I18n.t('errors.comment_not_found')] }, status: :not_found
  end
end
