module Errors
  def object_not_found!(context, object)
    context.errors = [not_found_message(object)]
    context.status = :not_found
    context.fail!
  end

  def object_invalid!(context, object)
    context.errors = validation_errors(object)
    context.status = :unprocessable_entity
    context.fail!
  end

  private

  def not_found_message(object)
    case object
    when :project then I18n.t('errors.project_not_found')
    when :task then I18n.t('errors.task_not_found')
    end
  end

  def validation_errors(object)
    case object
    when :project then context.project.errors.full_messages
    when :task then context.task.errors.full_messages
    when :comment then context.comment.errors.full_messages
    end
  end
end
