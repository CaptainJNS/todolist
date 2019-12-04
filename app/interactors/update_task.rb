class UpdateTask
  include Interactor
  include Errors

  def call
    context.task = Task.find_by(id: context.id)
    return object_not_found!(context, :task) unless context.task

    return context if context.task.update(context.params)

    object_invalid!(context, :task)
  end
end
