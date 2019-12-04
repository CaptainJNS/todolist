class CreateProject
  include Interactor
  include Errors

  def call
    context.project = Project.new(user: context.user, name: context.name)
    return context if context.project.save

    object_invalid!(:project)
  end
end
