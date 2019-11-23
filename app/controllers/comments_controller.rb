class CommentsController < ApplicationController
  def index
    task = Task.find_by(id: params[:task_id])
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    render json: Comment.where(task: task), status: :ok
  end

  def create
    task = Task.find_by(id: params[:task_id])
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    comment = Comment.new(task: task, body: params[:body], image: params[:image])
    return render json: comment, status: :created if comment.save

    render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    return comment.destroy if comment

    render json: { errors: [I18n.t('errors.comment_not_found')] }, status: :not_found
  end
end
