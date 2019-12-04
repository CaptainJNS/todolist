class UpdateProject
  include Interactor
  include Errors

  def call
    context.project = Project.find_by(user: context.user, id: context.id)

    return object_not_found!(:project) unless context.project

    return context if context.project.update(name: context.name)

    object_invalid!(:project)
  end
end
