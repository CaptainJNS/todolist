class CreateTask
  include Interactor

  def call
    project = Project.find_by(user: context.user, id: context.project_id)
    unless project
      context.status = :not_found
      context.errors = [I18n.t('errors.project_not_found')]
      return context.fail!
    end

    position = project.tasks.count + 1
    context.task = Task.new(project: project, name: context.name, position: position)
    return context if context.task.save

    context.errors = context.task.errors.full_messages
    context.status = :unprocessable_entity
    context.fail!
  end
end
