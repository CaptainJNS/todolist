class CreateTask
  include Interactor
  include Errors

  def call
    project = Project.find_by(user: context.user, id: context.project_id)
    return object_not_found!(context, :project) unless project

    context.task = Task.new(project: project, name: context.name, position: project.tasks.count + 1)
    return context if context.task.save

    object_invalid!(context, :task)
  end
end
