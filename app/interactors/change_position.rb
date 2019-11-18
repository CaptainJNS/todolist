class ChangePosition
  include Interactor

  def call
    context.status = :unprocessable_entity
    position = context.position.to_i
    context.task = Task.find_by(id: context.id)
    unless context.task
      context.status = :not_found
      context.errors = [I18n.t('errors.task_not_found')]
      return context.fail!
    end

    max_position = context.task.project.tasks.count
    if position.zero? || position > max_position
      context.errors = [I18n.t('errors.invalid_position')]
      return context.fail!
    end

    swap_positions(position)
  end

  private

  def swap_positions(position)
    another_task = Task.find_by(project: context.task.project, position: position)
    another_task&.update(position: context.task.position)
    context.task.update(position: position)
  end
end
