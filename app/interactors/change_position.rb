class ChangePosition
  include Interactor
  include Errors

  def call
    context.task = Task.find_by(id: context.id)
    return object_not_found!(context, :task) unless context.task

    swap_positions(context.position.to_i)
    return object_invalid!(context, :task) unless context.task.save
  end

  private

  def swap_positions(position)
    another_task = Task.find_by(project: context.task.project, position: position)
    another_task&.update(position: context.task.position)
    context.task.position = position
  end
end
