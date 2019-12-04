class UpdateTask
  include Interactor
  include Errors

  def call
    return object_not_found!(:task) unless context.task

    swap_position(context.position) if context.params[:position].present?
    return context if context.task.update(context.params)

    object_invalid!(:task)
  end

  private

  def swap_position(position)
    another_task = Task.find_by(project: context.task.project, position: position)
    another_task&.update(position: context.task.position)
  end
end
