class CreateTask
  include Interactor
  include Errors

  def call
    return object_not_found!(:project) unless context.project

    context.task = context.project.tasks.build(name: context.name, position: context.project.tasks.count + 1)
    return context if context.task.save

    object_invalid!(:task)
  end
end
