class Api::V1::CommentsController < ApplicationController
  resource_description do
    short I18n.t('docs.comments.short_description')
    description I18n.t('docs.comments.long_description')
    param :project_id, :number, I18n.t('docs.comments.params.project_id'), required: true
    param :task_id, :number, I18n.t('docs.comments.params.task_id'), required: true
  end

  def_param_group :comment do
    param :body, String, I18n.t('docs.comments.params.body'), required: true
    param :image, String, I18n.t('docs.comments.params.image')
  end

  api :GET, '/projects/:project_id/tasks/:task_id/comments', I18n.t('docs.comments.actions.index')
  def index
    return render json: { errors: [I18n.t('errors.task_not_found')] }, status: :not_found unless task

    render json: Comment.where(task: task), status: :ok
  end

  api :POST, '/projects/:project_id/tasks/:task_id/comments', I18n.t('docs.comments.actions.create')
  param_group :comment
  def create
    result = CreateComment.call(params: comment_params.merge(task: task))
    return render json: result.comment, status: :created if result.success?

    render json: { errors: result.errors }, status: result.status
  end

  api :DELETE, '/projects/:project_id/tasks/:task_id/comments/:id', I18n.t('docs.comments.actions.destroy')
  param :id, :number, I18n.t('docs.comments.params.id'), required: true
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
