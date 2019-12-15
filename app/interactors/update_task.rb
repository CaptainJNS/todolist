class UpdateTask
  include Interactor
  include Errors

  def call
    return object_not_found!(:task) unless context.task

    change_position(context.params[:position].to_i) if context.params[:position].present?
    return context if context.task.update(context.params.except(:position))

    object_invalid!(:task)
  end

  private

  def change_position(position)
    context.task.insert_at(position)
  rescue ArgumentError
    context.task.update(position: position)
  end
end
