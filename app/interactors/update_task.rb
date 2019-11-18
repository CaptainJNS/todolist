class UpdateTask
  include Interactor

  def call
    context.status = :unprocessable_entity
    if deadline_invalid?
      context.errors = [I18n.t('errors.deadline')]
      return context.fail!
    end

    context.task = Task.find_by(id: context.id)
    unless context.task
      context.status = :not_found
      context.errors = [I18n.t('errors.task_not_found')]
      return context.fail!
    end

    return context if context.task.update(context.params)

    context.errors = context.task.errors.full_messages
    context.fail!
  end

  private

  def deadline_invalid?
    return false if context.params[:deadline].nil?

    begin
      deadline = Date.parse(context.params[:deadline])
    rescue ArgumentError
      return true
    end

    deadline < Time.now
  end
end
