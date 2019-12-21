class UpdateTask
  include Interactor
  include Errors

  before do
    return object_not_found!(:task) unless context.task

    validate_position if context.params[:position].present?
  end

  after { check_tasks_complete if context.params[:done].present? }

  def call
    return unless context.success?

    change_position(position.to_i) if position.present?
    return object_invalid!(:task) unless context.task.update(general_task_data)

    context.data = {}
  end

  private

  def change_position(position)
    context.task.insert_at(position)
  end

  def all_tasks_complete(tasks)
    tasks.pluck(:done).all?(true)
  end

  def check_tasks_complete
    context.data = { messages: [I18n.t('messages.all_tasks_complete')] } if all_tasks_complete(context.task.project.tasks)
  end

  def validate_position
    return if context.params[:position].to_i.in?(1..context.task.project.tasks.count)

    context.task.errors.add(:base, I18n.t('errors.invalid_position'))
    object_invalid!(:task)
  end

  def position
    context.params[:position]
  end

  def general_task_data
    context.params.except(:position)
  end
end
