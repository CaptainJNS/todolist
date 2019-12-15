class CreateProject
  include Interactor
  include Errors

  def call
    context.project = context.user.projects.build(name: context.name)
    return context if context.project.save

    object_invalid!(:project)
  end
end
