class UpdateTask
  include Interactor
  include Errors

  def call
    return object_not_found!(:task) unless context.task

    change_position(context.params[:position].to_i) if context.params[:position].present?
    return object_invalid!(:task) unless context.task.update(context.params.except(:position))

    context.data = all_tasks_complete(context.task.project.tasks) ? { messages: [I18n.t('messages.all_tasks_complete')] } : {}
  end

  private

  def change_position(position)
    context.task.insert_at(position)
  rescue ArgumentError
    Task.acts_as_list_no_update { context.task.update(position: position) }
  end

  def all_tasks_complete(tasks)
    tasks.each { |t| return false unless t.done }

    true
  end
end
