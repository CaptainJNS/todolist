module Errors
  def object_not_found!(context, object)
    context.errors = [I18n.t("errors.#{object}_not_found")]
    context.status = :not_found
    context.fail!
  end

  def object_invalid!(context, object)
    context.errors = validation_errors(object)
    context.status = :unprocessable_entity
    context.fail!
  end

  private

  def validation_errors(object)
    case object
    when :project then context.project.errors.full_messages
    when :task then context.task.errors.full_messages
    when :comment then context.comment.errors.full_messages
    end
  end
end
