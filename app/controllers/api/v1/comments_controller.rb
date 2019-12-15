class Api::V1::CommentsController < ApplicationController
  resource_description do
    short I18n.t('docs.comments.short_description')
    description I18n.t('docs.comments.long_description')
  end

  def_param_group :comment do
    param :body, String, I18n.t('docs.comments.params.body'), required: true
    param :image, String, I18n.t('docs.comments.params.image')
  end

  api :GET, '/tasks/:task_id/comments', I18n.t('docs.comments.actions.index')
  param :task_id, :number, I18n.t('docs.comments.params.task_id'), required: true
  def index
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    render json: task.comments, status: :ok
  end

  api :POST, '/tasks/:task_id/comments', I18n.t('docs.comments.actions.create')
  param_group :comment
  param :task_id, :number, I18n.t('docs.comments.params.task_id'), required: true
  def create
    result = CreateComment.call(params: comment_params, task: task)
    return render json: result.comment, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :DELETE, '/comments/:id', I18n.t('docs.comments.actions.destroy')
  param :id, :number, I18n.t('docs.comments.params.id'), required: true
  def destroy
    return render json: { errors: [I18n.t('errors.comment_not_found')] }, status: :not_found unless comment

    comment.destroy
    render json: {}, status: :ok
  end

  private

  def task
    current_user.tasks.find_by(id: params[:task_id])
  end

  def comment
    current_user.comments.find_by(id: params[:id])
  end

  def comment_params
    params.permit(:body, :image)
  end
end
